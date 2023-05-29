//
//  MoviesAPI.swift
//  LearningTask-11.2
//
//  Created by jeovane.barbosa on 12/12/22.
//

import Foundation

class MoviesAPI {
    
    let session: URLSession
    let decoder: JSONDecoder
    var dataTask: URLSessionDataTask?
    let moviesUri: URL = URL(string: "https://swapi.dev/api/films")!
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder.decodingFormattedDates(with: DateFormatter.CustomPattern.yearMonthAndDay)) {
        self.session = session
        self.decoder = decoder
    }
    
    func getMovies(from uri: URL, completionHandler: @escaping (Films) -> Void,
                   failureHandler: @escaping (MoviesAPI.Error) -> Void) {
        dataTask?.cancel()
        
        dataTask = session.dataTask(with: uri) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    failureHandler(.unableToCompleteRequest(error))
                }
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                DispatchQueue.main.async {
                    failureHandler(.fetchFailed)
                }
                return
            }
            
            do{
                guard let self = self else {return}

                let dataWrapper = try self.decoder.decode(Films.self, from: data)
                
                DispatchQueue.main.async {
                    completionHandler(dataWrapper)
                }
                
            } catch {
                DispatchQueue.main.async {
                    failureHandler(.invalidData)
                }
            }
        }
        dataTask?.resume()
    }
}

extension MoviesAPI {
    enum Error: Swift.Error, LocalizedError {
        case unableToCompleteRequest(Swift.Error)
        case fetchFailed
        case invalidData
        
        var errorDescription: String? {
            switch self {
            case .unableToCompleteRequest(let error):
                return "Erro ao processar requisição: \(error.localizedDescription)"
                
            case .fetchFailed:
                return "Erro ao obter resposta do servidor"
                
            case .invalidData:
                return "Os dados recebidos do servidor são inválidos"
            }
        }
    }
}
