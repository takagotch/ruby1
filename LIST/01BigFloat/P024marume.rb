#!/usr/local/bin/ruby

require "BigFloat"

p c = BigFloat::new("1.23456").floor(4)     # c = 1.2345 になる。
p c = BigFloat::new("-1.23456").floor(4)    # c = -1.2346 になる。
p c = BigFloat::new("15.23456").floor(-1)   # c = 10.0 になる。
p c = BigFloat::new("-15.23456").floor(-1)  # c = -20.0 になる。

p c = BigFloat::new("1.23456").ceil(4)      # c = 1.2346 になる
p c = BigFloat::new("-1.23456").ceil(4)     # c = -1.2345 になる
p c = BigFloat::new("15.23456").ceil(-1)    # c = 20.0 になる
p c = BigFloat::new("-15.23456").ceil(-1)   # c = -10.0 になる

p c = BigFloat::new("1.23456").round(4)     # c = 1.2346 になる
p c = BigFloat::new("-1.23456").round(4)    # c = -1.2346 になる
p c = BigFloat::new("15.23456").round(-1)   # c = 20.0 にる
p c = BigFloat::new("-15.23456").round(-1)  # c = -20.0 にる

p c = BigFloat::new("1.23456").truncate(4)    # c = 1.2345 になる
p c = BigFloat::new("-1.23456").truncate(4)   # c = -1.2345 になる
p c = BigFloat::new("15.23456").truncate(-1)  # c = 10.0 になる
p c = BigFloat::new("-15.23456").truncate(-1) # c = -10.0 になる

