//
//  DetailViewModel.swift
//  CoinApp
//
//  Created by song on 2022/11/28.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
  
  @Published var overviewStatistics: [StatisticModel] = []
  @Published var additionalStatistics: [StatisticModel] = []
  
  @Published var coin: CoinModel
  private let coinDetailService: CoinDetailDataService
  private var cancellables = Set<AnyCancellable>()
  
  
  init(coin: CoinModel) {
    self.coin = coin
    self.coinDetailService = CoinDetailDataService(coin: coin)
    self.addSubscription()
  }
  
  private func addSubscription() {
    coinDetailService.$coinDetails
      .combineLatest($coin)
      .map({ (coinDetailModel, coinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) in
        
        //overView
        let price = coinModel.currentPrice.asCurrencyWith2Decimals()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChaange: priceChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCpStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChaange:  marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volum", value: volume)
        
        
        // additional
        let high = coinModel.high24H?.asCurrencyWith2Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith2Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange2 = coinModel.priceChange24H?.asCurrencyWith2Decimals() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange2, percentageChaange: pricePercentChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Chanage", value: marketCapChange, percentageChaange: marketCapPercentChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat  = StatisticModel(title: "Bolck Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let overViewArray: [StatisticModel] = [
          priceStat, marketCpStat, rankStat, volumeStat]
        
        let additionalArray: [StatisticModel] = [
          highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return (overViewArray, additionalArray)
      })
      .sink { [weak self] (returnedArrays) in
        self?.overviewStatistics = returnedArrays.overview
        self?.additionalStatistics = returnedArrays.additional
      }
      .store(in: &cancellables)
  }
}
