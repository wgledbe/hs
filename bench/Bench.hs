import Criterion.Main
import HB.BenchTwo
import Scratch.BenchTTH

main = defaultMain benches

benches = [benchTwo, benchTTH]
