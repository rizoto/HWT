//
//  main.swift
//  MLdigits
//
//  Created by Lubor Kolacny on 13/4/19.
//  Copyright © 2019 Lubor Kolacny. All rights reserved.
//

import Foundation
import CreateML

print("Creating ML model")

// source of trainig data
// http://yann.lecun.com/exdb/mnist/index.html
//[offset] [type]          [value]          [description]
//0000     32 bit integer  0x00000803(2051) magic number
//0004     32 bit integer  60000            number of images
//0008     32 bit integer  28               number of rows
//0012     32 bit integer  28               number of columns
//0016     unsigned byte   ??               pixel
//0017     unsigned byte   ??               pixel
//    ........
//xxxx     unsigned byte   ??               pixel

private let pathTrainingData = "/tmp/train-images-idx3-ubyte" // ungzipped file
private let pathTrainingLabels = "/tmp/train-labels-idx1-ubyte"
private let pathEvaluationData = "/tmp/t10k-images-idx3-ubyte" // ungzipped file
private let pathEvaluationLabels = "/tmp/t10k-labels-idx1-ubyte"
private let pathTraining = "/tmp/training"
private let pathEvaluation = "/tmp/evaluation"

if createPath(path:pathTraining) && createPath(path:pathEvaluation) &&
    createImages(dataPath: pathTrainingData, labelsPath: pathTrainingLabels, outputPath: pathTraining) &&
    createImages(dataPath: pathEvaluationData, labelsPath: pathEvaluationLabels, outputPath: pathEvaluation) {
   
    // ML training
    let parameters = MLImageClassifier.ModelParameters(validationData: .labeledDirectories(at: URL(fileURLWithPath: pathEvaluation)))
    let classifier = try MLImageClassifier(trainingData: .labeledDirectories(at: URL(fileURLWithPath: pathTraining)),
                                               parameters: parameters)
    print(classifier.description)
    
    // save model
    do {
        try classifier.write(toFile: "/tmp/ml_digits.mlmodel")
    } catch {
        print("Couldn't save the model")
    }
} else {
    print("Run ./dl_data.sh to get source files")
}
