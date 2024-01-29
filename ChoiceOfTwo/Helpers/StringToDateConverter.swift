//
//  StringToDateConverter.swift
//  ChoiceOfTwo
//
//  Created by Yaroslav Sokolov on 27/12/2023.
//

import Foundation
import AnilistApi

extension GetAnimeByQuery.Data.Page.Medium {
    
    
    func configureDate(isStartDate: Bool) -> String {
        if isStartDate {
            var day: String = self.startDate?.day == nil ? "_" : "\(self.startDate!.day!)"
            if day != "_" {
                if day.count == 1 {
                    day = "0" + day
                }
            }
            var month: String = self.startDate?.month == nil ? "_" : "\(self.startDate!.month!)"
            if month != "_" {
                if month.count == 1 {
                    month = "0" + month
                }
            }
            
            let year: String = self.startDate?.year == nil ? "_" : "\(self.startDate!.year!)"
            
            return day + "." +  month + "." + year
            
        } else {
            var day: String = self.endDate?.day == nil ? "_" : "\(self.endDate!.day!)"
            if day != "_" {
                if day.count == 1 {
                    day = "0" + day
                }
            }
            var month: String = self.endDate?.month == nil ? "_" : "\(self.endDate!.month!)"
            if month != "_" {
                if month.count == 1 {
                    month = "0" + month
                }
            }
            
            let year: String = self.endDate?.year == nil ? "_" : "\(self.endDate!.year!)"
            
            return day + "." +  month + "." + year
        }
    }
}

extension GetAnimeByQuery.Data.Page.Medium.Relations.Node {
    func configureDate(isStartDate: Bool) -> String {
        if isStartDate {
            var day: String = self.startDate?.day == nil ? "_" : "\(self.startDate!.day!)"
            if day != "_" {
                if day.count == 1 {
                    day = "0" + day
                }
            }
            var month: String = self.startDate?.month == nil ? "_" : "\(self.startDate!.month!)"
            if month != "_" {
                if month.count == 1 {
                    month = "0" + month
                }
            }
            
            let year: String = self.startDate?.year == nil ? "_" : "\(self.startDate!.year!)"
            
            return day + "." +  month + "." + year
            
        } else {
            var day: String = self.endDate?.day == nil ? "_" : "\(self.endDate!.day!)"
            if day != "_" {
                if day.count == 1 {
                    day = "0" + day
                }
            }
            var month: String = self.endDate?.month == nil ? "_" : "\(self.endDate!.month!)"
            if month != "_" {
                if month.count == 1 {
                    month = "0" + month
                }
            }
            
            let year: String = self.endDate?.year == nil ? "_" : "\(self.endDate!.year!)"
            
            return day + "." +  month + "." + year
        }
    }
}
