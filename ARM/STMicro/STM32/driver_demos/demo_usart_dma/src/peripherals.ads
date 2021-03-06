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

with Ada.Interrupts.Names; use Ada.Interrupts.Names;

with STM32F4.DMA;          use STM32F4.DMA;
with STM32F4.GPIO;         use STM32F4.GPIO;
with STM32F4.USARTs;       use STM32F4.USARTs;

with STM32F4_Discovery;    use STM32F4_Discovery;

package Peripherals is

   IO_Port : GPIO_Port renames GPIO_A;

   Transceiver : USART renames USART_2;

   Transceiver_AF : constant GPIO_Alternate_Function := GPIO_AF_USART2;

   TX_Pin : constant GPIO_Pin := Pin_2;
   RX_Pin : constant GPIO_Pin := Pin_3;

   Controller : DMA_Controller renames DMA_1;

   Tx_Channel : constant DMA_Channel_Selector := Channel_4;

   Tx_Stream : constant DMA_Stream_Selector := Stream_6;

   DMA_Tx_IRQ : constant Ada.Interrupts.Interrupt_Id := DMA1_Stream6_Interrupt;
   -- must match that of the selected controller and stream number!!!!

end Peripherals;
