/*
* <fp_util.svh>
* 
* Copyright (c) 2020-2021 Yosuke Ide <yosuke.ide@keio.jp>
* 
* This software is released under the MIT License.
* https://opensource.org/licenses/mit-license.php
*/

`ifndef _FP_UTIL_SVH_INCLUDED_
`define _FP_UTIL_SVH_INCLUDED_

`include "stddef.svh"
`include "type.svh"

virtual class FpUtils #( 
	parameter int PREC = 8,			// precision
	parameter int EXP = 3,			// exponent width
	parameter int ACT = `ACT_ReLU,	// Activation Function
	parameter string ATTR = "in",	// direction
	parameter DISP = `Enable		// print decoded result
);
	localparam FRAC = PREC - EXP - 1;
	localparam BIAS = (1 << (EXP-1)) - 1;

	/* set floating point value */
	task set;
		input				sign;
		input [EXP-1:0]		exp;
		input [FRAC-1:0]	frac;
		output [PREC-1:0]	dst;
		begin
			dst = {sign, exp, frac};
		end
	endtask

	/* set random value */
	task set_random;
		output [PREC-1:0]	dst;
		reg					sign;
		reg [EXP-1:0]		exp;
		reg [FRAC-1:0]		frac;
		begin
			sign = $random;
			exp = $random;
			frac = $random;
			dst = {sign, exp, frac};
		end
	endtask

	/* get maximum value */
	function [PREC-1:0] get_max;
		input			sign;
		reg	[EXP-1:0]	exp;
		reg [FRAC-1:0]	frac;
		begin
			exp = {EXP{1'b1}};
			frac = {FRAC{1'b0}};
			get_max = {sign, exp, frac};
		end
	endfunction

	/* decode floating point */
	function real decode;
		input [PREC-1:0]	fp;
		reg					sign;
		reg [EXP-1:0]		exp;
		reg [FRAC-1:0]		frac;
		integer				frac_ext;
		integer				shift;
		integer				mult;
		integer				div;
		real				rn;
		begin
			{sign, exp, frac} = fp;
			frac_ext = {1'b1, frac};
			if ( exp > BIAS + FRAC ) begin
				shift = exp - BIAS - FRAC;
				mult = 1 << shift;
				// TODO: calc shift before converting real type!!
				rn = (-1 ** sign ) * $itor(frac_ext) * mult;
			end else begin
				shift = BIAS + FRAC - exp;
				div = 1 << shift;
				rn = (-1 ** sign) * $itor(frac_ext) / div;
			end

			if ( ! (|(fp[PREC-2:0]))  ) begin
				rn = 0;
			end

			if ( DISP ) begin
				$display("%s, float: %x, float: %f", ATTR, fp, rn);
			end

			decode = rn;
		end
	endfunction

	function check_max;
		input [PREC-1:0]	in;
		real				rn;
		real				max;
		begin
			rn = this.decode(in);
			$write("MAX ");
			max = this.decode(this.get_max(in[PREC-1]));
			check_max = ( rn == max );
		end
	endfunction
endclass

class FpCalc #(
	/* input1 */
	parameter int I1_PREC = 8,
	parameter int I1_EXP = 3,
	parameter string I1_ATTR = "in1",
	/* input2 */
	parameter int I2_PREC = 16,
	parameter int I2_EXP = 4,
	parameter string I2_ATTR = "in2"
);

	/***** internal parameters *****/
	/* input1 */
	localparam I1_FRAC = I1_PREC - I1_EXP - 1;
	localparam I1_BIAS = (1 << (I1_EXP-1)) - 1;
	/* input2 */
	localparam I2_FRAC = I2_PREC - I2_EXP - 1;
	localparam I2_BIAS = (1 << (I2_EXP-1)) - 1;


	
	/***** class initialization *****/
	/* input 1 */
	FpUtils #(
		.PREC	( I1_PREC ),
		.EXP	( I1_EXP ),
		.ATTR	( I1_ATTR )
	) in1_fp;

	/* input 2 */
	FpUtils #(
		.PREC	( I2_PREC ),
		.EXP	( I2_EXP ),
		.ATTR	( I2_ATTR )
	) in2_fp;



	/***** calculations *****/
	function compare;
		input [I1_PREC-1:0]		in1;
		input [I2_PREC-1:0]		in2;
		real					ri1;
		real					ri2;
		begin
			ri1 = in1_fp.decode(in1);
			ri2 = in2_fp.decode(in2);

			compare = ( ri1 == ri2 );
		end
	endfunction

	function real mult;
		input [I1_PREC-1:0]		in1;
		input [I2_PREC-1:0]		in2;
		real					ri1;
		real					ri2;
		begin
			ri1 = in1_fp.decode(in1);
			ri2 = in2_fp.decode(in2);

			mult = ri1 * ri2;
		end
	endfunction

	function real add;
		input [I1_PREC-1:0]		in1;
		input [I2_PREC-1:0]		in2;
		real					ri1;
		real					ri2;
		begin
			ri1 = in1_fp.decode(in1);
			ri2 = in2_fp.decode(in2);

			add = ri1 + ri2;
		end
	endfunction

	function real sub;
		input [I1_PREC-1:0]		in1;
		input [I2_PREC-1:0]		in2;
		real					ri1;
		real					ri2;
		begin
			ri1 = in1_fp.decode(in1);
			ri2 = in2_fp.decode(in2);

			sub = ri1 - ri2;
		end
	endfunction

endclass

`endif // _FP_UTIL_SVH_INCLUDED_
