/*
* <int_util.svh>
* 
* Copyright (c) 2020-2021 Yosuke Ide <yosuke.ide@keio.jp>
* 
* This software is released under the MIT License.
* https://opensource.org/licenses/mit-license.php
*/

`ifndef _INT_UTIL_SVH_INCLUDED_
`define _INT_UTIL_SVH_INCLUDED_

`include "type.svh"

virtual class IntUtils #(
	parameter dconf_t CONF = `DEF_DCONF_INT,
	parameter actf_t ACT = `DEF_ACT,
	parameter string ATTR = "in",	// direction
	parameter DISP = `Enable		// print decoded result
);

	//***** internal parameter
	localparam SIGN = CONF.sign;
	localparam PREC = CONF.prec;
	localparam FRAC = CONF.frac;



	//***** set integer value
	task set (
		input [PREC-1:0]		in,
		output [PREC-1:0]		dst
	);

		dst = in;
	endtask



	//***** set random value
	static task set_random (
		output [PREC-1:0]		dst
	);

		dst = $random;
	endtask



	//***** return value with maximum absolute value
	static function [PREC-1:0] get_max (
		input			sign
	);

		if ( SIGN ) begin
			if ( sign ) begin
				get_max = {1'b1, {PREC-1{1'b0}}};
			end else begin
				get_max = {1'b0, {PREC-1{1'b1}}};
			end
		end else begin
			get_max = {PREC{1'b1}};
		end
	endfunction



	//***** decode integer
	static function int decode (
		input [PREC-1:0]		in
	);
		reg	 signed [PREC-1:0]	in_s;

		in_s = in;
		if ( SIGN ) begin
			if ( in[PREC-1] ) begin
				decode = in_s;
			end else begin
				decode = in;
			end
		end else begin
			decode = in;
		end
	endfunction



	//***** check if given value is maximum of the type
	static function check_max (
		input [PREC-1:0]		in
	);

		bit [PREC-1:0]			max;
		max = get_max(in[PREC-1]);
		check_max = ( in == max );
	endfunction

endclass


//***** Input calculation functions *****/
class IntCalc #(
	//*** input1
	parameter dconf_t I1_CONF = `DEF_DCONF_INT,
	parameter string I1_ATTR = "in1",
	//*** input2
	parameter dconf_t I2_CONF = `DEF_DCONF_INT,
	parameter string I2_ATTR = "in2"
);

	/***** internal parameters *****/
	/* input1 */
	localparam I1_PREC = I1_CONF.prec;
	/* input2 */
	localparam I2_PREC = I2_CONF.prec;



	/***** class initialization *****/
	/* input 1 */
	IntUtils #(
		.CONF	( I1_CONF ),
		.ATTR	( I1_ATTR )
	) in1_int;

	/* input 2 */
	IntUtils #(
		.CONF	( I2_CONF ),
		.ATTR	( I2_ATTR )
	) in2_int;

	/***** calculations *****/
	function compare;
		input [I1_PREC-1:0]		in1;
		input [I2_PREC-1:0]		in2;
		int						di1;
		int						di2;
		begin
			di1 = in1_int.decode(in1);
			di2 = in2_int.decode(in2);

			compare = ( di1 == di2 );
		end
	endfunction

	function real mult;
		input [I1_PREC-1:0]		in1;
		input [I2_PREC-1:0]		in2;
		int						di1;
		int						di2;
		begin
			di1 = in1_int.decode(in1);
			di2 = in2_int.decode(in2);

			mult = di1 * di2;
		end
	endfunction

	function real add;
		input [I1_PREC-1:0]		in1;
		input [I2_PREC-1:0]		in2;
		int						di1;
		int						di2;
		begin
			di1 = in1_int.decode(in1);
			di2 = in2_int.decode(in2);
			$display("in1: %d, in2: %d", di1, di2);

			add = di1 + di2;
		end
	endfunction

	function real sub;
		input [I1_PREC-1:0]		in1;
		input [I2_PREC-1:0]		in2;
		int						di1;
		int						di2;
		begin
			di1 = in1_int.decode(in1);
			di2 = in2_int.decode(in2);

			sub = di1 - di2;
		end
	endfunction

endclass

`endif // _INT_UTIL_SVH_INCLUDED_
