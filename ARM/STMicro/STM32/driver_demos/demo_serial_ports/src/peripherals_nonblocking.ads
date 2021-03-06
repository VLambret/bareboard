------------------------------------------------------------------------------
--                                                                          --
--                    Copyright (C) 2015, AdaCore                           --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of STMicroelectronics nor the names of its       --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with Ada.Interrupts;        use Ada.Interrupts;
with Ada.Interrupts.Names;  use Ada.Interrupts.Names;
with STM32F4.RCC;           use STM32F4.RCC;
with STM32F4.GPIO;          use STM32F4.GPIO;
with Serial_IO.Nonblocking; use Serial_IO.Nonblocking;

with STM32F4_Discovery;           use STM32F4_Discovery;

package Peripherals_Nonblocking is

   Hardware : aliased Peripheral_Descriptor :=
                (Port               => GPIO_B'Access,
                 Transceiver        => USART_1'Access,
                 Enable_Port_Clock  => GPIOB_Clock_Enable'Access,
                 Enable_USART_Clock => USART1_Clock_Enable'Access,
                 Transceiver_AF     => GPIO_AF_USART1,
                 Tx_Pin             => Pin_6,
                 Rx_Pin             => Pin_7);

   Transceiver_Interrupt : constant Interrupt_Id := USART1_Interrupt;

   COM : Serial_Port (Transceiver_Interrupt, Hardware'Access);

end Peripherals_Nonblocking;
