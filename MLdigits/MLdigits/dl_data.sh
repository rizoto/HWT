#!/bin/sh

#  dl_data.sh
#  MLdigits
#
#  Created by Lubor Kolacny on 14/4/19.
#  Copyright © 2019 Lubor Kolacny. All rights reserved.
for i in "train-images-idx3-ubyte" "train-labels-idx1-ubyte" "t10k-images-idx3-ubyte" "t10k-labels-idx1-ubyte"
do
    curl http://yann.lecun.com/exdb/mnist/$i.gz -o /tmp/$i.gz &&  gunzip /tmp/$i.gz
done
