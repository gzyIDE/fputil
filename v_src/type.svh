/*
* <type.svh>
* 
* Copyright (c) 2020-2021 Yosuke Ide <yosuke.ide@keio.jp>
* 
* This software is released under the MIT License.
* http://opensource.org/licenses/mit-license.php
*/

`ifndef _TYPE_SVH_INCLUDED_
`define _TYPE_SVH_INCLUDED_

//***** Calculation Data Type
typedef enum byte {
	INT,	// integer
	FXP,	// fixed point
	FP		// floating point
} dtype_t;

//*** Default type
`define DEF_TYPE		INT



//***** Data Port Configuration 
typedef struct {
	dtype_t		dtype;	// data type
	bit			sign;	// sign(= 1) or unsigned(= 0)
	byte 		prec;	// precision
	byte 		frac;	// fraction part (for fixed point, floating point)
} dconf_t;

//*** Default Configurations
//* Default Settings
`define DEF_DCONF		dconf_t'{dtype:`DEF_TYPE, sign:1'b0, prec:4, frac:0}
`define DEF_DCONFS		dconf_t'{dtype:`DEF_TYPE, sign:1'b0, prec:4, frac:0}
`define DEF_DCONFL		dconf_t'{dtype:`DEF_TYPE, sign:1'b0, prec:16, frac:0}
//* Integer
`define DEF_DCONF_INT	dconf_t'{dtype:INT, sign:1'b0, prec:8, frac:0}
`define DEF_DCONFS_INT	dconf_t'{dtype:INT, sign:1'b0, prec:4, frac:0}
`define DEF_DCONFL_INT	dconf_t'{dtype:INT, sign:1'b0, prec:16, frac:0}
//* Fixed Point
`define DEF_DCONF_FXP	dconf_t'{dtype:FXP, sign:1'b0, prec:8, frac:4}
`define DEF_DCONFS_FXP	dconf_t'{dtype:FXP, sign:1'b0, prec:4, frac:2}
`define DEF_DCONFL_FXP	dconf_t'{dtype:FXP, sign:1'b0, prec:16, frac:8}
//* Floating Point
`define DEF_DCONF_FP	dconf_t'{dtype:FP, sign:1'b1, prec:8, frac:3}
`define DEF_DCONFS_FP	dconf_t'{dtype:FP, sign:1'b1, prec:4, frac:2}
`define DEF_DCONFL_FP	dconf_t'{dtype:FP, sign:1'b1, prec:16, frac:5}

`endif //_TYPE_SVH_INCLUDED_
