------------------------------------------------------------------------------
--                                                                          --
--                  Copyright (C) 2015-2016, AdaCore                        --
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

--  This program demonstrates reading the VBat (battery voltage) value from
--  an ADC unit, using interrupts.

--  Note that you will likely need to reset the board manually after loading.

with ADC_Interrupt_Handling;
with Ada.Synchronous_Task_Control;  use Ada.Synchronous_Task_Control;

with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);

with STM32F429_Discovery;  use STM32F429_Discovery;

with STM32F4;       use STM32F4;
with STM32F4.ADC;   use STM32F4.ADC;

with STM32F4.ILI9341;
with Bitmapped_Drawing;
with BMP_Fonts;

procedure Demo_ADC_VBat_Interrupts is

   All_Regular_Conversions : constant Regular_Channel_Conversions :=
      (1 => (Channel => VBat.Channel, Sample_Time => Sample_15_Cycles));

   Counts  : Word;
   Voltage : Word;  -- in millivolts

   -----------------
   -- LCD_Drawing --
   -----------------

   package LCD_Drawing is new Bitmapped_Drawing
     (Color     => STM32F4.ILI9341.Colors,
      Set_Pixel => STM32F4.ILI9341.Set_Pixel);

   -----------
   -- Print --
   -----------

   procedure Print (X, Y : Natural; Value : Word; Suffix : String := "") is
      Value_Image : constant String := Value'Img;
      use LCD_Drawing, BMP_Fonts, STM32F4.ILI9341;
   begin
      Draw_String
        ((X, Y),
         Msg        => Value_Image (2 .. Value_Image'Last) & Suffix & "   ",
         Font       => Font16x24,  -- arbitrary
         Foreground => White,      -- arbitrary
         Background => Black);     -- arbitrary
   end Print;

begin
   Initialize_LEDs;
   Initialize_LCD_Hardware;
   STM32F4.ILI9341.Set_Orientation (To => STM32F4.ILI9341.Portrait_2);

   Enable_Clock (VBat.ADC.all);

   Configure_Common_Properties
     (Mode           => Independent,
      Prescalar      => PCLK2_Div_2,
      DMA_Mode       => Disabled,
      Sampling_Delay => Sampling_Delay_5_Cycles);

   Configure_Unit
     (VBat.ADC.all,
      Resolution => ADC_Resolution_12_Bits,
      Alignment  => Right_Aligned);

   Configure_Regular_Conversions
     (VBat.ADC.all,
      Continuous  => False,
      Trigger     => Software_Triggered,
      Enable_EOC  => True,
      Conversions => All_Regular_Conversions);

   Enable_Interrupts (VBat.ADC.all, Regular_Channel_Conversion_Complete);

   Enable (VBat.ADC.all);

   loop
      Start_Conversion (VBat.ADC.all);

      Suspend_Until_True (ADC_Interrupt_Handling.Regular_Channel_EOC);

      Counts := Word (Conversion_Value (VBat.ADC.all));

      Print (0, 0, Counts);

      Voltage := ((Counts * VBat_Bridge_Divisor) * ADC_Supply_Voltage) / 16#FFF#;
      --  16#FFF# because we are using 12-bit conversion resolution

      Print (0, 24, Voltage, "mv");

      Toggle (Green);
   end loop;
end Demo_ADC_VBat_Interrupts;
