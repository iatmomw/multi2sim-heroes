set terminal png
set output "cct-messages.png"

set title "Cache Coherence Traffic: Messages"

set xlabel "Cycle"
set ylabel "Path"

# plot in grey-scale
set palette gray

# use dark colors for larger values
set palette negative

# zrange
set cbrange [0:10]

set autoscale xy

unset ytics

set view map

# do not display data filename
set nokey

# plot!
splot 'cct-messages.txt' matrix with image
