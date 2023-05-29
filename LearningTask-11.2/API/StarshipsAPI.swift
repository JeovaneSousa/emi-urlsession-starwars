//
//  StarshipsAPI.swift
//  LearningTask-11.2
//
//  Created by rafael.rollo on 03/11/2022.
//

import Foundation

class StarshipsAPI {

    var session: URLSession
    var decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func getAll(batching urls: [URL],
                completionHandler: @escaping ([Starship], StarshipsAPI.Error?) -> Void) {
        var items: [Starship] = []
        var notLoadedURLs: [URL] = []
        
        let dataTaskGroup = DispatchGroup()
        
        urls.forEach { url in
            dataTaskGroup.enter()
            
            getStarship(from: url) { starship in
                items.append(starship)
                dataTaskGroup.leave()
                
            } failureHandler: { error in
                print(error)
                notLoadedURLs.append(url)
                
                dataTaskGroup.leave()
            }
        }
                
        dataTaskGroup.notify(queue: .main) {
            let possibleError = notLoadedURLs.isEmpty
                ? Optional<StarshipsAPI.Error>.none
                : Optional<StarshipsAPI.Error>.some(.starshipsNotLoaded(notLoadedURLs))
            
            completionHandler(items, possibleError)
        }
    }
    
    private func getStarship(from uri: URL,
                             completionHandler: @escaping (Starship) -> Void,
                             failureHandler: @escaping (StarshipsAPI.Error) -> Void) {
        let dataTask = session.dataTask(with: uri) { [weak self] data, response, error in
            if let error = error {
                failureHandler(.unableToRequest(error))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                failureHandler(.fetchFailed)
                return
            }
                        
            do {
                guard let self = self else { return }
                
                let startship = try self.decoder.decode(Starship.self, from: data)
                completionHandler(startship)
                
            } catch {
                failureHandler(.invalidData)
            }
        }
        
        dataTask.resume()
    }
}

extension StarshipsAPI {
    typealias SError = Swift.Error
    
    enum Error: SError, LocalizedError {
        case unableToRequest(SError)
        case fetchFailed
        case invalidData
        case starshipsNotLoaded([URL])
        
        var errorDescription: String? {
            switch self {
            case .unableToRequest(let error):
                return "Erro ao processar a requisição \(error.localizedDescription)"
            
            case .fetchFailed:
                return "Erro ao obter resposta do servidor"
            
            case .invalidData:
                return "Os dados recebidos do servidor são inválidos"
                
            case .starshipsNotLoaded:
                return "Algumas naves podem não ter sido carregadas"
            }
        }
    }
}
