//
//  MovieErrors.swift
//  spm
//
//  Created by Joel Tavares on 13/06/25.
//

import Foundation

enum MovieError: Error{
    case InvalidUrl
    //case NotFound
    //case ServerError
    case InvalidResponse
    case InvalidData
    case genresUnavailable
    case castUnavailable(movieId: Int)
    case unknown
}
