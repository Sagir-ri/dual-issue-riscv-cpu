把分支预测的结果打了一拍传回pc_control_unit
clock=60MHz WNS=-1.901ns
后面把synthesize的设置改为performance_high再重新跑一次看看implementation的timing有无变化 同频率时钟变为-1.
把+ -换成ip核(Adder Fabric)得到了更差的时序 同频率下WNS=-2.058ns
如果ip核用DSP48 WNS=-3.128ns
