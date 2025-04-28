#!/bin/python3

# Sets convenience variables useful when debugging FW on an NXP S32K3xx MCU
#
# Addresses are correct but the types are sourced from the standard NXP
# libraries, which you may or may not be using in your project
#
# Import with `source` within gdb / .gdbinit / macros / ...

import gdb
from dataclasses import dataclass

@dataclass
class NxpReg():
    addr: int
    name: str
    nxp_type: str

_regs = [
    # ARM core registers
    NxpReg(0xe000e000, 'nvic', 'S32_NVIC_Type'),
    NxpReg(0xe000e000, 'scb', 'S32_SCB_Type'),
    # ADC
    NxpReg(0x400a0000, 'adc0', 'ADC_Type'),
    NxpReg(0x400a4000, 'adc1', 'ADC_Type'),
    NxpReg(0x400a8000, 'adc2', 'ADC_Type'),
    # timers
    NxpReg(0x400B0000, 'pit0', 'PIT_Type'),
    NxpReg(0x400B4000, 'pit1', 'PIT_Type'),
    NxpReg(0x402FC000, 'pit2', 'PIT_Type'),
    # watchdogs
    NxpReg(0x40270000, 'swt0', 'SWT_Type'),
    NxpReg(0x4046C000, 'swt1', 'SWT_Type'),
    # Interrupt Router CP (core2core irq generation/status)
    NxpReg(0x40260200, 'ircp', 'IPC_MSCM_IRCPnIRx_Type'),
    # MC_ peripherals
    NxpReg(0x4028C000, 'rgm', 'MC_RGM_Type'), # Reset Generation Module
    NxpReg(0x402DC000, 'me', 'MC_ME_Type'), # Mode Entry (cpu cores pwr manager)
    # pins I/O - System Integration Unit Lite2 (SIUL2)
    # With an enum going like A00 = 0, A31 = 31, B00 = 32, ...
    # offsets of pin-wide registers w.r.t. A00 is ((pin XOR 3) - 3)
    NxpReg(0x40290000, 'siul2', 'SIUL2_Type'),
    # memories
    NxpReg(0x402EC000, 'flash', 'FLASH_Type'),
    NxpReg(0x40268000, 'pflash0', 'PFLASH_Type'),
    # communication
    NxpReg(0x40304000, 'can0', 'FLEXCAN_Type'),
    NxpReg(0x40308000, 'can1', 'FLEXCAN_Type'),
    NxpReg(0x4030C000, 'can2', 'FLEXCAN_Type'),
    NxpReg(0x40310000, 'can3', 'FLEXCAN_Type'),
    NxpReg(0x40314000, 'can4', 'FLEXCAN_Type'),
    NxpReg(0x40318000, 'can5', 'FLEXCAN_Type'),
    NxpReg(0x4031C000, 'can6', 'FLEXCAN_Type'),
    NxpReg(0x40320000, 'can7', 'FLEXCAN_Type'),
    NxpReg(0x40570000, 'can8', 'FLEXCAN_Type'),
    NxpReg(0x40574000, 'can9', 'FLEXCAN_Type'),
    # misc
    NxpReg(0x40380000, 'crc', 'CRC_Type'),
    NxpReg(0x40384000, 'fccu', 'FCCU_Type'), # Fault Collection & Control Unit
]

for reg in _regs:
    print(f'Debug access to 0x{reg.addr:04x} via ${reg.name:8} ', end='')
    try:
        sym = gdb.lookup_type(f'{reg.nxp_type}')
    except gdb.error:
        sym = None

    if sym is not None: # if symbol was found
        gdb.execute(f'set ${reg.name} = (({reg.nxp_type} *){reg.addr})')
        print('')
    else:
        gdb.execute(f'set ${reg.name} = {reg.addr}')
        print('(ADDRESS ONLY)')
