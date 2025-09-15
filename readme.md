# RISC-V Dual-Issue CPU (Verilog)

## 简介
本项目实现了一个基于 **RISC-V 指令集** 的 **双发射（Dual-Issue）流水线 CPU**，使用 Verilog HDL 编写。  
设计目标是探索现代处理器中的关键结构，包括指令发射、旁路转发、分支预测以及存储访问控制等模块。  

该 CPU 通过模块化的方式实现，便于学习和扩展，是一个兼顾教学与研究的处理器原型。

## 特性
- **双发射流水线**：支持同时发射两条指令，提高指令级并行度（ILP）。  
- **五级流水线设计**：包括取指 (Fetch)、译码 (Decode)、执行 (Execute)、访存 (Memory)、提交 (Commit)。  
- **旁路机制 (Bypass Unit)**：解决数据相关 (RAW hazard)，减少流水线停顿。  
- **分支预测器**：基于两位饱和计数器的分支预测，提高分支指令执行效率。  
- **异常与冲突处理**：  
  - 数据相关的暂停控制  
  - 分支预测失败时的流水线清空与恢复  
- **指令与数据存储接口**：通过 IROM/DRAM 接口访问指令和数据，便于仿真与扩展。  
- **支持的指令类型**：  
  - R-type（算术/逻辑运算、乘法/除法）  
  - I-type（立即数运算、加载）  
  - S-type（存储）  
  - B-type（分支）  
  - U-type（LUI、AUIPC）  
  - J-type（JAL、JALR）  

## 代码结构
主要模块：  
- `alu.v`：算术逻辑单元 (ALU)  
- `alu_control.v`：根据指令生成 ALU 控制信号  
- `branch_judge.v`：分支判断单元  
- `branch_predict_2_bit.v`：两位饱和分支预测器  
- `bypass.v`：数据旁路与暂停控制  
- `data_path.v`：CPU 核心数据通路  
- `data_ram_control.v`：数据存储访问控制  
- `regfile.v`：32 个通用寄存器的寄存器堆  
- 其他流水线寄存器与控制模块  

## 仿真与运行
1. 使用 [iverilog](https://steveicarus.github.io/iverilog/) 或 [ModelSim](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html) 进行编译与仿真。  
2. 提供测试用例（可加载 `.mem` 文件作为指令存储内容）。  
3. 支持波形调试（推荐 [GTKWave](http://gtkwave.sourceforge.net/)）。  

## 适用人群
- 学习计算机体系结构与流水线设计的本科/研究生  
- 对 RISC-V 指令集感兴趣的开发者  
- 想要研究 **双发射 CPU** 的设计者  
