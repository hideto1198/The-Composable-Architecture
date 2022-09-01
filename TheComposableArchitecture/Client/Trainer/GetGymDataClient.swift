//
//  GetGymDataClient.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/08/26.
//

import Foundation
import ComposableArchitecture
import FirebaseFirestore

struct GetGymDataClient {
    var fetch: (_ year: Int, _ month: Int, _ dates: [[DateEntity]], _ targetName: String?) -> Effect<[String: Any], Failure>
    struct Failure: Error, Equatable {}
}

extension GetGymDataClient {
    static let live = GetGymDataClient(fetch: { year, month, dates, targetName in
        Effect.task {
            let db = Firestore.firestore()
            var result: [[DateEntity]] = dates
            var trainerName: String = ""
            var ita_trainers: [String] = []
            var nino_trainers: [String] = []
            if let targetName = targetName {
                trainerName = targetName
            } else {
                trainerName = UserDefaults.standard.string(forKey: "userName")!
            }
            let documents = try await db.collection("Trainer").getDocuments()
            for document in documents.documents {
                if document.get("place") as! String == "板垣店" {
                    ita_trainers.append(document.get("name") as! String)
                } else {
                    nino_trainers.append(document.get("name") as! String)
                }
            }
            for i in dates.indices {
                for n in dates[i].indices {
                    guard dates[i][n].date != "" else { continue }
                    let response = try await db.collection("Reservation").document("\(year)-\(month)").collection("date").document("\(dates[i][n].date)").collection("Time").getDocuments()
                    guard !response.documents.isEmpty else {
                        result[i][n].state = ""
                        continue
                    }
                    for document in response.documents {
                        if trainerName == "ジム全体" {
                            if !document.data().keys.isEmpty {
                                result[i][n].state = checkDate(target: "\(year)/\(month)/\(dates[i][n].date)") ? "予" : "済"
                                break
                            } else {
                                result[i][n].state = ""
                            }
                        } else if trainerName == "板垣店" {
                            if !document.data().keys.filter({ ita_trainers.contains($0) }).isEmpty {
                                result[i][n].state = checkDate(target: "\(year)/\(month)/\(dates[i][n].date)") ? "予" : "済"
                                break
                            } else {
                                result[i][n].state = ""
                            }
                        } else if trainerName == "二の宮店" {
                            if !document.data().keys.filter({ nino_trainers.contains($0) }).isEmpty {
                                result[i][n].state = checkDate(target: "\(year)/\(month)/\(dates[i][n].date)") ? "予" : "済"
                                break
                            } else {
                                result[i][n].state = ""
                            }
                        } else {
                            if !document.data().keys.filter({ $0 == trainerName }).isEmpty {
                                result[i][n].state = checkDate(target: "\(year)/\(month)/\(dates[i][n].date)") ? "予" : "済"
                                break
                            } else {
                                result[i][n].state = ""
                            }
                        }
                    }
                }
            }
            return [
                "dates": result,
                "year": year,
                "month": month
            ]
        }
        .mapError{ _ in Failure() }
        .eraseToEffect()
    })
}

// MARK: - 当日より以前の場合はFalseを返す
fileprivate func checkDate(target: String) -> Bool {
    let today: Date = Date()
    let yesterday: Date = Calendar.current.date(byAdding: .day, value: -1, to: today)!
    var dateFormatter: DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        return dateFormatter
    }
    let targetDate: Date = dateFormatter.date(from: "\(target)")!
    if targetDate.compare(yesterday) == .orderedAscending {
        return false
    } else {
        return true
    }
}
