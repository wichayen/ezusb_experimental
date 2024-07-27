set SIMPRJ_DIR "./"


alias com {
vcom     "$SIMPRJ_DIR/tb_PRJ_TOP.vhd"
vcom     "$SIMPRJ_DIR/../PLL.vhd"
vcom     "$SIMPRJ_DIR/../RAM_2PORT.vhd"
vcom     "$SIMPRJ_DIR/../SIM_FIFO.vhd"
vcom     "$SIMPRJ_DIR/../PRJ_TOP.vhd"
}


alias sim {
vsim -t ps work.tb_PRJ_TOP -gui
}
#vsim -t ns work.tb_PRJ_TOP


alias rst {
restart -f
}


alias q {
quit -sim
}




alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "sim                           -- start simulation"
  echo
  echo "rst                           -- restart simulation"
  echo
  echo "q                             -- quit simulation"
}



h
