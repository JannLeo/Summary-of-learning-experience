module CSR(
  input         clock,
  input         reset,
  input         io_stall,
  input  [2:0]  io_cmd,
  input  [31:0] io_in,
  output [31:0] io_out,
  input  [31:0] io_pc,
  input  [31:0] io_addr,
  input  [31:0] io_inst,
  input         io_illegal,
  input  [1:0]  io_st_type,
  input  [2:0]  io_ld_type,
  input         io_pc_check,
  output        io_expt,
  output [31:0] io_evec,
  output [31:0] io_epc
);
  reg [31:0] time$; // @[CSR.scala 105:25]
  reg [31:0] _RAND_0;
  reg [31:0] timeh; // @[CSR.scala 106:25]
  reg [31:0] _RAND_1;
  reg [31:0] cycle; // @[CSR.scala 107:25]
  reg [31:0] _RAND_2;
  reg [31:0] cycleh; // @[CSR.scala 108:25]
  reg [31:0] _RAND_3;
  reg [31:0] instret; // @[CSR.scala 109:25]
  reg [31:0] _RAND_4;
  reg [31:0] instreth; // @[CSR.scala 110:25]
  reg [31:0] _RAND_5;
  reg [1:0] PRV; // @[CSR.scala 119:21]
  reg [31:0] _RAND_6;
  reg [1:0] PRV1; // @[CSR.scala 120:21]
  reg [31:0] _RAND_7;
  reg  IE; // @[CSR.scala 123:20]
  reg [31:0] _RAND_8;
  reg  IE1; // @[CSR.scala 124:20]
  reg [31:0] _RAND_9;
  reg  MTIP; // @[CSR.scala 140:21]
  reg [31:0] _RAND_10;
  reg  MTIE; // @[CSR.scala 143:21]
  reg [31:0] _RAND_11;
  reg  MSIP; // @[CSR.scala 146:21]
  reg [31:0] _RAND_12;
  reg  MSIE; // @[CSR.scala 149:21]
  reg [31:0] _RAND_13;
  reg [31:0] mtimecmp; // @[CSR.scala 155:21]
  reg [31:0] _RAND_14;
  reg [31:0] mscratch; // @[CSR.scala 157:21]
  reg [31:0] _RAND_15;
  reg [31:0] mepc; // @[CSR.scala 159:17]
  reg [31:0] _RAND_16;
  reg [31:0] mcause; // @[CSR.scala 160:19]
  reg [31:0] _RAND_17;
  reg [31:0] mbadaddr; // @[CSR.scala 161:21]
  reg [31:0] _RAND_18;
  reg [31:0] mtohost; // @[CSR.scala 163:24]
  reg [31:0] _RAND_19;
  reg [31:0] mfromhost; // @[CSR.scala 164:22]
  reg [31:0] _RAND_20;
  wire [11:0] csr_addr; // @[CSR.scala 101:25]
  wire [4:0] rs1_addr; // @[CSR.scala 102:25]
  wire [2:0] _T_102; // @[Cat.scala 30:58]
  wire [3:0] _T_103; // @[Cat.scala 30:58]
  wire [2:0] _T_104; // @[Cat.scala 30:58]
  wire [5:0] _T_106; // @[Cat.scala 30:58]
  wire [9:0] _T_107; // @[Cat.scala 30:58]
  wire [31:0] mstatus; // @[Cat.scala 30:58]
  wire [1:0] _T_126; // @[Cat.scala 30:58]
  wire [3:0] _T_127; // @[Cat.scala 30:58]
  wire [24:0] _T_129; // @[Cat.scala 30:58]
  wire [25:0] _T_130; // @[Cat.scala 30:58]
  wire [27:0] _T_131; // @[Cat.scala 30:58]
  wire [31:0] mip; // @[Cat.scala 30:58]
  wire [1:0] _T_136; // @[Cat.scala 30:58]
  wire [3:0] _T_137; // @[Cat.scala 30:58]
  wire [24:0] _T_139; // @[Cat.scala 30:58]
  wire [25:0] _T_140; // @[Cat.scala 30:58]
  wire [27:0] _T_141; // @[Cat.scala 30:58]
  wire [31:0] mie; // @[Cat.scala 30:58]
  wire  _T_154; // @[Lookup.scala 9:38]
  wire  _T_158; // @[Lookup.scala 9:38]
  wire  _T_162; // @[Lookup.scala 9:38]
  wire  _T_166; // @[Lookup.scala 9:38]
  wire  _T_170; // @[Lookup.scala 9:38]
  wire  _T_174; // @[Lookup.scala 9:38]
  wire  _T_178; // @[Lookup.scala 9:38]
  wire  _T_182; // @[Lookup.scala 9:38]
  wire  _T_186; // @[Lookup.scala 9:38]
  wire  _T_190; // @[Lookup.scala 9:38]
  wire  _T_194; // @[Lookup.scala 9:38]
  wire  _T_198; // @[Lookup.scala 9:38]
  wire  _T_202; // @[Lookup.scala 9:38]
  wire  _T_206; // @[Lookup.scala 9:38]
  wire  _T_210; // @[Lookup.scala 9:38]
  wire  _T_214; // @[Lookup.scala 9:38]
  wire  _T_218; // @[Lookup.scala 9:38]
  wire  _T_222; // @[Lookup.scala 9:38]
  wire  _T_226; // @[Lookup.scala 9:38]
  wire  _T_230; // @[Lookup.scala 9:38]
  wire  _T_234; // @[Lookup.scala 9:38]
  wire  _T_238; // @[Lookup.scala 9:38]
  wire  _T_242; // @[Lookup.scala 9:38]
  wire  _T_246; // @[Lookup.scala 9:38]
  wire  _T_250; // @[Lookup.scala 9:38]
  wire  _T_254; // @[Lookup.scala 9:38]
  wire  _T_258; // @[Lookup.scala 9:38]
  wire  _T_262; // @[Lookup.scala 9:38]
  wire  _T_266; // @[Lookup.scala 9:38]
  wire [31:0] _T_267; // @[Lookup.scala 11:37]
  wire [31:0] _T_268; // @[Lookup.scala 11:37]
  wire [31:0] _T_269; // @[Lookup.scala 11:37]
  wire [31:0] _T_270; // @[Lookup.scala 11:37]
  wire [31:0] _T_271; // @[Lookup.scala 11:37]
  wire [31:0] _T_272; // @[Lookup.scala 11:37]
  wire [31:0] _T_273; // @[Lookup.scala 11:37]
  wire [31:0] _T_274; // @[Lookup.scala 11:37]
  wire [31:0] _T_275; // @[Lookup.scala 11:37]
  wire [31:0] _T_276; // @[Lookup.scala 11:37]
  wire [31:0] _T_277; // @[Lookup.scala 11:37]
  wire [31:0] _T_278; // @[Lookup.scala 11:37]
  wire [31:0] _T_279; // @[Lookup.scala 11:37]
  wire [31:0] _T_280; // @[Lookup.scala 11:37]
  wire [31:0] _T_281; // @[Lookup.scala 11:37]
  wire [31:0] _T_282; // @[Lookup.scala 11:37]
  wire [31:0] _T_283; // @[Lookup.scala 11:37]
  wire [31:0] _T_284; // @[Lookup.scala 11:37]
  wire [31:0] _T_285; // @[Lookup.scala 11:37]
  wire [31:0] _T_286; // @[Lookup.scala 11:37]
  wire [31:0] _T_287; // @[Lookup.scala 11:37]
  wire [31:0] _T_288; // @[Lookup.scala 11:37]
  wire [31:0] _T_289; // @[Lookup.scala 11:37]
  wire [31:0] _T_290; // @[Lookup.scala 11:37]
  wire [31:0] _T_291; // @[Lookup.scala 11:37]
  wire [31:0] _T_292; // @[Lookup.scala 11:37]
  wire [31:0] _T_293; // @[Lookup.scala 11:37]
  wire [31:0] _T_294; // @[Lookup.scala 11:37]
  wire [31:0] _T_295; // @[Lookup.scala 11:37]
  wire [1:0] _T_296; // @[CSR.scala 204:27]
  wire  privValid; // @[CSR.scala 204:34]
  wire  privInst; // @[CSR.scala 205:26]
  wire  _T_297; // @[CSR.scala 206:40]
  wire  _T_299; // @[CSR.scala 206:31]
  wire  _T_300; // @[CSR.scala 206:28]
  wire  _T_301; // @[CSR.scala 206:56]
  wire  _T_303; // @[CSR.scala 206:47]
  wire  isEcall; // @[CSR.scala 206:44]
  wire  _T_305; // @[CSR.scala 207:28]
  wire  isEbreak; // @[CSR.scala 207:44]
  wire  isEret; // @[CSR.scala 208:44]
  wire  _T_430; // @[CSR.scala 209:61]
  wire  _T_431; // @[CSR.scala 209:61]
  wire  _T_432; // @[CSR.scala 209:61]
  wire  _T_433; // @[CSR.scala 209:61]
  wire  _T_434; // @[CSR.scala 209:61]
  wire  _T_435; // @[CSR.scala 209:61]
  wire  _T_436; // @[CSR.scala 209:61]
  wire  _T_437; // @[CSR.scala 209:61]
  wire  _T_438; // @[CSR.scala 209:61]
  wire  _T_439; // @[CSR.scala 209:61]
  wire  _T_440; // @[CSR.scala 209:61]
  wire  _T_441; // @[CSR.scala 209:61]
  wire  _T_442; // @[CSR.scala 209:61]
  wire  _T_443; // @[CSR.scala 209:61]
  wire  _T_444; // @[CSR.scala 209:61]
  wire  _T_445; // @[CSR.scala 209:61]
  wire  _T_446; // @[CSR.scala 209:61]
  wire  _T_447; // @[CSR.scala 209:61]
  wire  _T_448; // @[CSR.scala 209:61]
  wire  _T_449; // @[CSR.scala 209:61]
  wire  _T_450; // @[CSR.scala 209:61]
  wire  _T_451; // @[CSR.scala 209:61]
  wire  _T_452; // @[CSR.scala 209:61]
  wire  _T_453; // @[CSR.scala 209:61]
  wire  _T_454; // @[CSR.scala 209:61]
  wire  _T_455; // @[CSR.scala 209:61]
  wire  _T_456; // @[CSR.scala 209:61]
  wire  csrValid; // @[CSR.scala 209:61]
  wire [1:0] _T_457; // @[CSR.scala 210:27]
  wire [1:0] _T_458; // @[CSR.scala 210:36]
  wire  _T_460; // @[CSR.scala 210:36]
  wire  _T_461; // @[CSR.scala 210:53]
  wire  _T_462; // @[CSR.scala 210:41]
  wire  _T_463; // @[CSR.scala 210:79]
  wire  csrRO; // @[CSR.scala 210:67]
  wire  _T_464; // @[CSR.scala 211:26]
  wire  _T_465; // @[CSR.scala 211:45]
  wire  _T_467; // @[CSR.scala 211:61]
  wire  _T_468; // @[CSR.scala 211:49]
  wire  wen; // @[CSR.scala 211:36]
  wire [31:0] _T_470; // @[CSR.scala 214:22]
  wire [31:0] _T_471; // @[CSR.scala 215:24]
  wire [31:0] _T_472; // @[CSR.scala 215:22]
  wire  _T_473; // @[Mux.scala 46:19]
  wire [31:0] _T_474; // @[Mux.scala 46:16]
  wire  _T_475; // @[Mux.scala 46:19]
  wire [31:0] _T_476; // @[Mux.scala 46:16]
  wire  _T_477; // @[Mux.scala 46:19]
  wire [31:0] wdata; // @[Mux.scala 46:16]
  wire  _T_478; // @[CSR.scala 217:44]
  wire  iaddrInvalid; // @[CSR.scala 217:34]
  wire [1:0] _T_533; // @[CSR.scala 219:29]
  wire  _T_535; // @[CSR.scala 219:36]
  wire  _T_536; // @[CSR.scala 219:65]
  wire  _T_538; // @[Mux.scala 46:19]
  wire  _T_539; // @[Mux.scala 46:16]
  wire  _T_540; // @[Mux.scala 46:19]
  wire  _T_541; // @[Mux.scala 46:16]
  wire  _T_542; // @[Mux.scala 46:19]
  wire  laddrInvalid; // @[Mux.scala 46:16]
  wire  _T_548; // @[Mux.scala 46:19]
  wire  _T_549; // @[Mux.scala 46:16]
  wire  _T_550; // @[Mux.scala 46:19]
  wire  saddrInvalid; // @[Mux.scala 46:16]
  wire  _T_551; // @[CSR.scala 222:25]
  wire  _T_552; // @[CSR.scala 222:41]
  wire  _T_553; // @[CSR.scala 222:57]
  wire [1:0] _T_554; // @[CSR.scala 223:20]
  wire  _T_556; // @[CSR.scala 223:27]
  wire  _T_558; // @[CSR.scala 223:35]
  wire  _T_560; // @[CSR.scala 223:48]
  wire  _T_561; // @[CSR.scala 223:45]
  wire  _T_562; // @[CSR.scala 223:31]
  wire  _T_563; // @[CSR.scala 222:73]
  wire  _T_564; // @[CSR.scala 223:67]
  wire  _T_565; // @[CSR.scala 223:60]
  wire  _T_568; // @[CSR.scala 224:24]
  wire  _T_569; // @[CSR.scala 223:76]
  wire  _T_570; // @[CSR.scala 224:39]
  wire  _T_571; // @[CSR.scala 224:50]
  wire [7:0] _GEN_260; // @[CSR.scala 225:27]
  wire [7:0] _T_572; // @[CSR.scala 225:27]
  wire [31:0] _GEN_261; // @[CSR.scala 225:20]
  wire [32:0] _T_573; // @[CSR.scala 225:20]
  wire [31:0] _T_574; // @[CSR.scala 225:20]
  wire [32:0] _T_576; // @[CSR.scala 229:16]
  wire [31:0] _T_577; // @[CSR.scala 229:16]
  wire [31:0] _T_578; // @[CSR.scala 230:13]
  wire  _T_580; // @[CSR.scala 230:13]
  wire [32:0] _T_582; // @[CSR.scala 230:36]
  wire [31:0] _T_583; // @[CSR.scala 230:36]
  wire [31:0] _GEN_1; // @[CSR.scala 230:19]
  wire [32:0] _T_585; // @[CSR.scala 231:18]
  wire [31:0] _T_586; // @[CSR.scala 231:18]
  wire [31:0] _T_587; // @[CSR.scala 232:14]
  wire  _T_589; // @[CSR.scala 232:14]
  wire [32:0] _T_591; // @[CSR.scala 232:39]
  wire [31:0] _T_592; // @[CSR.scala 232:39]
  wire [31:0] _GEN_2; // @[CSR.scala 232:20]
  wire  _T_594; // @[CSR.scala 233:27]
  wire  _T_596; // @[CSR.scala 233:52]
  wire  _T_597; // @[CSR.scala 233:61]
  wire  _T_598; // @[CSR.scala 233:72]
  wire  _T_599; // @[CSR.scala 233:48]
  wire  _T_601; // @[CSR.scala 233:88]
  wire  isInstRet; // @[CSR.scala 233:85]
  wire [32:0] _T_603; // @[CSR.scala 234:40]
  wire [31:0] _T_604; // @[CSR.scala 234:40]
  wire [31:0] _GEN_3; // @[CSR.scala 234:19]
  wire [31:0] _T_605; // @[CSR.scala 235:29]
  wire  _T_607; // @[CSR.scala 235:29]
  wire  _T_608; // @[CSR.scala 235:18]
  wire [32:0] _T_610; // @[CSR.scala 235:58]
  wire [31:0] _T_611; // @[CSR.scala 235:58]
  wire [31:0] _GEN_4; // @[CSR.scala 235:35]
  wire [29:0] _T_614; // @[CSR.scala 239:23]
  wire [31:0] _GEN_262; // @[CSR.scala 239:28]
  wire [31:0] _T_615; // @[CSR.scala 239:28]
  wire [3:0] _GEN_263; // @[CSR.scala 243:47]
  wire [4:0] _T_622; // @[CSR.scala 243:47]
  wire [3:0] _T_623; // @[CSR.scala 243:47]
  wire [1:0] _T_624; // @[CSR.scala 244:20]
  wire [3:0] _T_625; // @[CSR.scala 243:20]
  wire [3:0] _T_626; // @[CSR.scala 242:20]
  wire [3:0] _T_627; // @[CSR.scala 241:20]
  wire [3:0] _T_628; // @[CSR.scala 240:20]
  wire  _T_630; // @[CSR.scala 249:25]
  wire  _T_631; // @[CSR.scala 249:41]
  wire [31:0] _GEN_5; // @[CSR.scala 249:58]
  wire  _T_633; // @[CSR.scala 256:21]
  wire [1:0] _T_634; // @[CSR.scala 257:22]
  wire  _T_635; // @[CSR.scala 258:22]
  wire [1:0] _T_636; // @[CSR.scala 259:22]
  wire  _T_637; // @[CSR.scala 260:22]
  wire  _T_638; // @[CSR.scala 262:26]
  wire  _T_639; // @[CSR.scala 263:22]
  wire  _T_641; // @[CSR.scala 266:26]
  wire  _T_644; // @[CSR.scala 270:26]
  wire  _T_645; // @[CSR.scala 271:26]
  wire  _T_646; // @[CSR.scala 272:26]
  wire  _T_647; // @[CSR.scala 273:26]
  wire  _T_648; // @[CSR.scala 274:26]
  wire [31:0] _T_650; // @[CSR.scala 274:56]
  wire [34:0] _GEN_264; // @[CSR.scala 274:63]
  wire [34:0] _T_652; // @[CSR.scala 274:63]
  wire  _T_653; // @[CSR.scala 275:26]
  wire [31:0] _T_655; // @[CSR.scala 275:60]
  wire  _T_656; // @[CSR.scala 276:26]
  wire  _T_657; // @[CSR.scala 277:26]
  wire  _T_658; // @[CSR.scala 278:26]
  wire  _T_659; // @[CSR.scala 279:26]
  wire  _T_660; // @[CSR.scala 280:26]
  wire  _T_661; // @[CSR.scala 281:26]
  wire  _T_662; // @[CSR.scala 282:26]
  wire  _T_663; // @[CSR.scala 283:26]
  wire  _T_664; // @[CSR.scala 284:26]
  wire [31:0] _GEN_6; // @[CSR.scala 284:45]
  wire [31:0] _GEN_7; // @[CSR.scala 283:42]
  wire [31:0] _GEN_8; // @[CSR.scala 283:42]
  wire [31:0] _GEN_9; // @[CSR.scala 282:43]
  wire [31:0] _GEN_10; // @[CSR.scala 282:43]
  wire [31:0] _GEN_11; // @[CSR.scala 282:43]
  wire [31:0] _GEN_12; // @[CSR.scala 281:44]
  wire [31:0] _GEN_13; // @[CSR.scala 281:44]
  wire [31:0] _GEN_14; // @[CSR.scala 281:44]
  wire [31:0] _GEN_15; // @[CSR.scala 281:44]
  wire [31:0] _GEN_16; // @[CSR.scala 280:41]
  wire [31:0] _GEN_17; // @[CSR.scala 280:41]
  wire [31:0] _GEN_18; // @[CSR.scala 280:41]
  wire [31:0] _GEN_19; // @[CSR.scala 280:41]
  wire [31:0] _GEN_20; // @[CSR.scala 280:41]
  wire [31:0] _GEN_21; // @[CSR.scala 279:42]
  wire [31:0] _GEN_22; // @[CSR.scala 279:42]
  wire [31:0] _GEN_23; // @[CSR.scala 279:42]
  wire [31:0] _GEN_24; // @[CSR.scala 279:42]
  wire [31:0] _GEN_25; // @[CSR.scala 279:42]
  wire [31:0] _GEN_26; // @[CSR.scala 279:42]
  wire [31:0] _GEN_27; // @[CSR.scala 278:45]
  wire [31:0] _GEN_28; // @[CSR.scala 278:45]
  wire [31:0] _GEN_29; // @[CSR.scala 278:45]
  wire [31:0] _GEN_30; // @[CSR.scala 278:45]
  wire [31:0] _GEN_31; // @[CSR.scala 278:45]
  wire [31:0] _GEN_32; // @[CSR.scala 278:45]
  wire [31:0] _GEN_33; // @[CSR.scala 278:45]
  wire [31:0] _GEN_34; // @[CSR.scala 277:43]
  wire [31:0] _GEN_35; // @[CSR.scala 277:43]
  wire [31:0] _GEN_36; // @[CSR.scala 277:43]
  wire [31:0] _GEN_37; // @[CSR.scala 277:43]
  wire [31:0] _GEN_38; // @[CSR.scala 277:43]
  wire [31:0] _GEN_39; // @[CSR.scala 277:43]
  wire [31:0] _GEN_40; // @[CSR.scala 277:43]
  wire [31:0] _GEN_41; // @[CSR.scala 277:43]
  wire [31:0] _GEN_42; // @[CSR.scala 276:44]
  wire [31:0] _GEN_43; // @[CSR.scala 276:44]
  wire [31:0] _GEN_44; // @[CSR.scala 276:44]
  wire [31:0] _GEN_45; // @[CSR.scala 276:44]
  wire [31:0] _GEN_46; // @[CSR.scala 276:44]
  wire [31:0] _GEN_47; // @[CSR.scala 276:44]
  wire [31:0] _GEN_48; // @[CSR.scala 276:44]
  wire [31:0] _GEN_49; // @[CSR.scala 276:44]
  wire [31:0] _GEN_50; // @[CSR.scala 276:44]
  wire [31:0] _GEN_51; // @[CSR.scala 275:42]
  wire [31:0] _GEN_52; // @[CSR.scala 275:42]
  wire [31:0] _GEN_53; // @[CSR.scala 275:42]
  wire [31:0] _GEN_54; // @[CSR.scala 275:42]
  wire [31:0] _GEN_55; // @[CSR.scala 275:42]
  wire [31:0] _GEN_56; // @[CSR.scala 275:42]
  wire [31:0] _GEN_57; // @[CSR.scala 275:42]
  wire [31:0] _GEN_58; // @[CSR.scala 275:42]
  wire [31:0] _GEN_59; // @[CSR.scala 275:42]
  wire [31:0] _GEN_60; // @[CSR.scala 275:42]
  wire [34:0] _GEN_61; // @[CSR.scala 274:40]
  wire [31:0] _GEN_62; // @[CSR.scala 274:40]
  wire [31:0] _GEN_63; // @[CSR.scala 274:40]
  wire [31:0] _GEN_64; // @[CSR.scala 274:40]
  wire [31:0] _GEN_65; // @[CSR.scala 274:40]
  wire [31:0] _GEN_66; // @[CSR.scala 274:40]
  wire [31:0] _GEN_67; // @[CSR.scala 274:40]
  wire [31:0] _GEN_68; // @[CSR.scala 274:40]
  wire [31:0] _GEN_69; // @[CSR.scala 274:40]
  wire [31:0] _GEN_70; // @[CSR.scala 274:40]
  wire [31:0] _GEN_71; // @[CSR.scala 274:40]
  wire [31:0] _GEN_72; // @[CSR.scala 273:44]
  wire [34:0] _GEN_73; // @[CSR.scala 273:44]
  wire [31:0] _GEN_74; // @[CSR.scala 273:44]
  wire [31:0] _GEN_75; // @[CSR.scala 273:44]
  wire [31:0] _GEN_76; // @[CSR.scala 273:44]
  wire [31:0] _GEN_77; // @[CSR.scala 273:44]
  wire [31:0] _GEN_78; // @[CSR.scala 273:44]
  wire [31:0] _GEN_79; // @[CSR.scala 273:44]
  wire [31:0] _GEN_80; // @[CSR.scala 273:44]
  wire [31:0] _GEN_81; // @[CSR.scala 273:44]
  wire [31:0] _GEN_82; // @[CSR.scala 273:44]
  wire [31:0] _GEN_83; // @[CSR.scala 273:44]
  wire [31:0] _GEN_84; // @[CSR.scala 272:44]
  wire [31:0] _GEN_85; // @[CSR.scala 272:44]
  wire [34:0] _GEN_86; // @[CSR.scala 272:44]
  wire [31:0] _GEN_87; // @[CSR.scala 272:44]
  wire [31:0] _GEN_88; // @[CSR.scala 272:44]
  wire [31:0] _GEN_89; // @[CSR.scala 272:44]
  wire [31:0] _GEN_90; // @[CSR.scala 272:44]
  wire [31:0] _GEN_91; // @[CSR.scala 272:44]
  wire [31:0] _GEN_92; // @[CSR.scala 272:44]
  wire [31:0] _GEN_93; // @[CSR.scala 272:44]
  wire [31:0] _GEN_94; // @[CSR.scala 272:44]
  wire [31:0] _GEN_95; // @[CSR.scala 272:44]
  wire [31:0] _GEN_96; // @[CSR.scala 272:44]
  wire [31:0] _GEN_97; // @[CSR.scala 271:42]
  wire [31:0] _GEN_98; // @[CSR.scala 271:42]
  wire [31:0] _GEN_99; // @[CSR.scala 271:42]
  wire [34:0] _GEN_100; // @[CSR.scala 271:42]
  wire [31:0] _GEN_101; // @[CSR.scala 271:42]
  wire [31:0] _GEN_102; // @[CSR.scala 271:42]
  wire [31:0] _GEN_103; // @[CSR.scala 271:42]
  wire [31:0] _GEN_104; // @[CSR.scala 271:42]
  wire [31:0] _GEN_105; // @[CSR.scala 271:42]
  wire [31:0] _GEN_106; // @[CSR.scala 271:42]
  wire [31:0] _GEN_107; // @[CSR.scala 271:42]
  wire [31:0] _GEN_108; // @[CSR.scala 271:42]
  wire [31:0] _GEN_109; // @[CSR.scala 271:42]
  wire [31:0] _GEN_110; // @[CSR.scala 270:41]
  wire [31:0] _GEN_111; // @[CSR.scala 270:41]
  wire [31:0] _GEN_112; // @[CSR.scala 270:41]
  wire [31:0] _GEN_113; // @[CSR.scala 270:41]
  wire [34:0] _GEN_114; // @[CSR.scala 270:41]
  wire [31:0] _GEN_115; // @[CSR.scala 270:41]
  wire [31:0] _GEN_116; // @[CSR.scala 270:41]
  wire [31:0] _GEN_117; // @[CSR.scala 270:41]
  wire [31:0] _GEN_118; // @[CSR.scala 270:41]
  wire [31:0] _GEN_119; // @[CSR.scala 270:41]
  wire [31:0] _GEN_120; // @[CSR.scala 270:41]
  wire [31:0] _GEN_121; // @[CSR.scala 270:41]
  wire [31:0] _GEN_122; // @[CSR.scala 270:41]
  wire  _GEN_123; // @[CSR.scala 266:39]
  wire  _GEN_124; // @[CSR.scala 266:39]
  wire [31:0] _GEN_125; // @[CSR.scala 266:39]
  wire [31:0] _GEN_126; // @[CSR.scala 266:39]
  wire [31:0] _GEN_127; // @[CSR.scala 266:39]
  wire [31:0] _GEN_128; // @[CSR.scala 266:39]
  wire [34:0] _GEN_129; // @[CSR.scala 266:39]
  wire [31:0] _GEN_130; // @[CSR.scala 266:39]
  wire [31:0] _GEN_131; // @[CSR.scala 266:39]
  wire [31:0] _GEN_132; // @[CSR.scala 266:39]
  wire [31:0] _GEN_133; // @[CSR.scala 266:39]
  wire [31:0] _GEN_134; // @[CSR.scala 266:39]
  wire [31:0] _GEN_135; // @[CSR.scala 266:39]
  wire [31:0] _GEN_136; // @[CSR.scala 266:39]
  wire [31:0] _GEN_137; // @[CSR.scala 266:39]
  wire  _GEN_138; // @[CSR.scala 262:39]
  wire  _GEN_139; // @[CSR.scala 262:39]
  wire  _GEN_140; // @[CSR.scala 262:39]
  wire  _GEN_141; // @[CSR.scala 262:39]
  wire [31:0] _GEN_142; // @[CSR.scala 262:39]
  wire [31:0] _GEN_143; // @[CSR.scala 262:39]
  wire [31:0] _GEN_144; // @[CSR.scala 262:39]
  wire [31:0] _GEN_145; // @[CSR.scala 262:39]
  wire [34:0] _GEN_146; // @[CSR.scala 262:39]
  wire [31:0] _GEN_147; // @[CSR.scala 262:39]
  wire [31:0] _GEN_148; // @[CSR.scala 262:39]
  wire [31:0] _GEN_149; // @[CSR.scala 262:39]
  wire [31:0] _GEN_150; // @[CSR.scala 262:39]
  wire [31:0] _GEN_151; // @[CSR.scala 262:39]
  wire [31:0] _GEN_152; // @[CSR.scala 262:39]
  wire [31:0] _GEN_153; // @[CSR.scala 262:39]
  wire [31:0] _GEN_154; // @[CSR.scala 262:39]
  wire [1:0] _GEN_155; // @[CSR.scala 256:38]
  wire  _GEN_156; // @[CSR.scala 256:38]
  wire [1:0] _GEN_157; // @[CSR.scala 256:38]
  wire  _GEN_158; // @[CSR.scala 256:38]
  wire  _GEN_159; // @[CSR.scala 256:38]
  wire  _GEN_160; // @[CSR.scala 256:38]
  wire  _GEN_161; // @[CSR.scala 256:38]
  wire  _GEN_162; // @[CSR.scala 256:38]
  wire [31:0] _GEN_163; // @[CSR.scala 256:38]
  wire [31:0] _GEN_164; // @[CSR.scala 256:38]
  wire [31:0] _GEN_165; // @[CSR.scala 256:38]
  wire [31:0] _GEN_166; // @[CSR.scala 256:38]
  wire [34:0] _GEN_167; // @[CSR.scala 256:38]
  wire [31:0] _GEN_168; // @[CSR.scala 256:38]
  wire [31:0] _GEN_169; // @[CSR.scala 256:38]
  wire [31:0] _GEN_170; // @[CSR.scala 256:38]
  wire [31:0] _GEN_171; // @[CSR.scala 256:38]
  wire [31:0] _GEN_172; // @[CSR.scala 256:38]
  wire [31:0] _GEN_173; // @[CSR.scala 256:38]
  wire [31:0] _GEN_174; // @[CSR.scala 256:38]
  wire [31:0] _GEN_175; // @[CSR.scala 256:38]
  wire [1:0] _GEN_176; // @[CSR.scala 255:21]
  wire  _GEN_177; // @[CSR.scala 255:21]
  wire [1:0] _GEN_178; // @[CSR.scala 255:21]
  wire  _GEN_179; // @[CSR.scala 255:21]
  wire  _GEN_180; // @[CSR.scala 255:21]
  wire  _GEN_181; // @[CSR.scala 255:21]
  wire  _GEN_182; // @[CSR.scala 255:21]
  wire  _GEN_183; // @[CSR.scala 255:21]
  wire [31:0] _GEN_184; // @[CSR.scala 255:21]
  wire [31:0] _GEN_185; // @[CSR.scala 255:21]
  wire [31:0] _GEN_186; // @[CSR.scala 255:21]
  wire [31:0] _GEN_187; // @[CSR.scala 255:21]
  wire [34:0] _GEN_188; // @[CSR.scala 255:21]
  wire [31:0] _GEN_189; // @[CSR.scala 255:21]
  wire [31:0] _GEN_190; // @[CSR.scala 255:21]
  wire [31:0] _GEN_191; // @[CSR.scala 255:21]
  wire [31:0] _GEN_192; // @[CSR.scala 255:21]
  wire [31:0] _GEN_193; // @[CSR.scala 255:21]
  wire [31:0] _GEN_194; // @[CSR.scala 255:21]
  wire [31:0] _GEN_195; // @[CSR.scala 255:21]
  wire [31:0] _GEN_196; // @[CSR.scala 255:21]
  wire [1:0] _GEN_197; // @[CSR.scala 250:24]
  wire  _GEN_198; // @[CSR.scala 250:24]
  wire [1:0] _GEN_199; // @[CSR.scala 250:24]
  wire  _GEN_200; // @[CSR.scala 250:24]
  wire  _GEN_201; // @[CSR.scala 250:24]
  wire  _GEN_202; // @[CSR.scala 250:24]
  wire  _GEN_203; // @[CSR.scala 250:24]
  wire  _GEN_204; // @[CSR.scala 250:24]
  wire [31:0] _GEN_205; // @[CSR.scala 250:24]
  wire [31:0] _GEN_206; // @[CSR.scala 250:24]
  wire [31:0] _GEN_207; // @[CSR.scala 250:24]
  wire [31:0] _GEN_208; // @[CSR.scala 250:24]
  wire [34:0] _GEN_209; // @[CSR.scala 250:24]
  wire [31:0] _GEN_210; // @[CSR.scala 250:24]
  wire [31:0] _GEN_211; // @[CSR.scala 250:24]
  wire [31:0] _GEN_212; // @[CSR.scala 250:24]
  wire [31:0] _GEN_213; // @[CSR.scala 250:24]
  wire [31:0] _GEN_214; // @[CSR.scala 250:24]
  wire [31:0] _GEN_215; // @[CSR.scala 250:24]
  wire [31:0] _GEN_216; // @[CSR.scala 250:24]
  wire [31:0] _GEN_217; // @[CSR.scala 250:24]
  wire [34:0] _GEN_218; // @[CSR.scala 238:19]
  wire [31:0] _GEN_219; // @[CSR.scala 238:19]
  wire [1:0] _GEN_220; // @[CSR.scala 238:19]
  wire  _GEN_221; // @[CSR.scala 238:19]
  wire [1:0] _GEN_222; // @[CSR.scala 238:19]
  wire  _GEN_223; // @[CSR.scala 238:19]
  wire [31:0] _GEN_224; // @[CSR.scala 238:19]
  wire  _GEN_225; // @[CSR.scala 238:19]
  wire  _GEN_226; // @[CSR.scala 238:19]
  wire  _GEN_227; // @[CSR.scala 238:19]
  wire  _GEN_228; // @[CSR.scala 238:19]
  wire [31:0] _GEN_229; // @[CSR.scala 238:19]
  wire [31:0] _GEN_230; // @[CSR.scala 238:19]
  wire [31:0] _GEN_231; // @[CSR.scala 238:19]
  wire [31:0] _GEN_232; // @[CSR.scala 238:19]
  wire [31:0] _GEN_233; // @[CSR.scala 238:19]
  wire [31:0] _GEN_234; // @[CSR.scala 238:19]
  wire [31:0] _GEN_235; // @[CSR.scala 238:19]
  wire [31:0] _GEN_236; // @[CSR.scala 238:19]
  wire [31:0] _GEN_237; // @[CSR.scala 238:19]
  wire [31:0] _GEN_238; // @[CSR.scala 238:19]
  wire [34:0] _GEN_239; // @[CSR.scala 237:19]
  wire [31:0] _GEN_240; // @[CSR.scala 237:19]
  wire [1:0] _GEN_241; // @[CSR.scala 237:19]
  wire  _GEN_242; // @[CSR.scala 237:19]
  wire [1:0] _GEN_243; // @[CSR.scala 237:19]
  wire  _GEN_244; // @[CSR.scala 237:19]
  wire [31:0] _GEN_245; // @[CSR.scala 237:19]
  wire  _GEN_246; // @[CSR.scala 237:19]
  wire  _GEN_247; // @[CSR.scala 237:19]
  wire  _GEN_248; // @[CSR.scala 237:19]
  wire  _GEN_249; // @[CSR.scala 237:19]
  wire [31:0] _GEN_250; // @[CSR.scala 237:19]
  wire [31:0] _GEN_251; // @[CSR.scala 237:19]
  wire [31:0] _GEN_252; // @[CSR.scala 237:19]
  wire [31:0] _GEN_253; // @[CSR.scala 237:19]
  wire [31:0] _GEN_254; // @[CSR.scala 237:19]
  wire [31:0] _GEN_255; // @[CSR.scala 237:19]
  wire [31:0] _GEN_256; // @[CSR.scala 237:19]
  wire [31:0] _GEN_257; // @[CSR.scala 237:19]
  wire [31:0] _GEN_258; // @[CSR.scala 237:19]
  wire [31:0] _GEN_259; // @[CSR.scala 237:19]
  assign csr_addr = io_inst[31:20]; // @[CSR.scala 101:25]
  assign rs1_addr = io_inst[19:15]; // @[CSR.scala 102:25]
  assign _T_102 = {IE1,PRV}; // @[Cat.scala 30:58]
  assign _T_103 = {_T_102,IE}; // @[Cat.scala 30:58]
  assign _T_104 = {1'h0,PRV1}; // @[Cat.scala 30:58]
  assign _T_106 = {3'h0,_T_104}; // @[Cat.scala 30:58]
  assign _T_107 = {_T_106,_T_103}; // @[Cat.scala 30:58]
  assign mstatus = {22'h0,_T_107}; // @[Cat.scala 30:58]
  assign _T_126 = {MSIP,1'h0}; // @[Cat.scala 30:58]
  assign _T_127 = {_T_126,2'h0}; // @[Cat.scala 30:58]
  assign _T_129 = {24'h0,MTIP}; // @[Cat.scala 30:58]
  assign _T_130 = {_T_129,1'h0}; // @[Cat.scala 30:58]
  assign _T_131 = {_T_130,2'h0}; // @[Cat.scala 30:58]
  assign mip = {_T_131,_T_127}; // @[Cat.scala 30:58]
  assign _T_136 = {MSIE,1'h0}; // @[Cat.scala 30:58]
  assign _T_137 = {_T_136,2'h0}; // @[Cat.scala 30:58]
  assign _T_139 = {24'h0,MTIE}; // @[Cat.scala 30:58]
  assign _T_140 = {_T_139,1'h0}; // @[Cat.scala 30:58]
  assign _T_141 = {_T_140,2'h0}; // @[Cat.scala 30:58]
  assign mie = {_T_141,_T_137}; // @[Cat.scala 30:58]
  assign _T_154 = 12'hc00 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_158 = 12'hc01 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_162 = 12'hc02 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_166 = 12'hc80 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_170 = 12'hc81 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_174 = 12'hc82 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_178 = 12'h900 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_182 = 12'h901 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_186 = 12'h902 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_190 = 12'h980 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_194 = 12'h981 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_198 = 12'h982 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_202 = 12'hf00 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_206 = 12'hf01 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_210 = 12'hf10 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_214 = 12'h301 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_218 = 12'h302 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_222 = 12'h304 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_226 = 12'h321 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_230 = 12'h701 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_234 = 12'h741 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_238 = 12'h340 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_242 = 12'h341 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_246 = 12'h342 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_250 = 12'h343 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_254 = 12'h344 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_258 = 12'h780 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_262 = 12'h781 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_266 = 12'h300 == csr_addr; // @[Lookup.scala 9:38]
  assign _T_267 = _T_266 ? mstatus : 32'h0; // @[Lookup.scala 11:37]
  assign _T_268 = _T_262 ? mfromhost : _T_267; // @[Lookup.scala 11:37]
  assign _T_269 = _T_258 ? mtohost : _T_268; // @[Lookup.scala 11:37]
  assign _T_270 = _T_254 ? mip : _T_269; // @[Lookup.scala 11:37]
  assign _T_271 = _T_250 ? mbadaddr : _T_270; // @[Lookup.scala 11:37]
  assign _T_272 = _T_246 ? mcause : _T_271; // @[Lookup.scala 11:37]
  assign _T_273 = _T_242 ? mepc : _T_272; // @[Lookup.scala 11:37]
  assign _T_274 = _T_238 ? mscratch : _T_273; // @[Lookup.scala 11:37]
  assign _T_275 = _T_234 ? timeh : _T_274; // @[Lookup.scala 11:37]
  assign _T_276 = _T_230 ? time$ : _T_275; // @[Lookup.scala 11:37]
  assign _T_277 = _T_226 ? mtimecmp : _T_276; // @[Lookup.scala 11:37]
  assign _T_278 = _T_222 ? mie : _T_277; // @[Lookup.scala 11:37]
  assign _T_279 = _T_218 ? 32'h0 : _T_278; // @[Lookup.scala 11:37]
  assign _T_280 = _T_214 ? 32'h100 : _T_279; // @[Lookup.scala 11:37]
  assign _T_281 = _T_210 ? 32'h0 : _T_280; // @[Lookup.scala 11:37]
  assign _T_282 = _T_206 ? 32'h0 : _T_281; // @[Lookup.scala 11:37]
  assign _T_283 = _T_202 ? 32'h100100 : _T_282; // @[Lookup.scala 11:37]
  assign _T_284 = _T_198 ? instreth : _T_283; // @[Lookup.scala 11:37]
  assign _T_285 = _T_194 ? timeh : _T_284; // @[Lookup.scala 11:37]
  assign _T_286 = _T_190 ? cycleh : _T_285; // @[Lookup.scala 11:37]
  assign _T_287 = _T_186 ? instret : _T_286; // @[Lookup.scala 11:37]
  assign _T_288 = _T_182 ? time$ : _T_287; // @[Lookup.scala 11:37]
  assign _T_289 = _T_178 ? cycle : _T_288; // @[Lookup.scala 11:37]
  assign _T_290 = _T_174 ? instreth : _T_289; // @[Lookup.scala 11:37]
  assign _T_291 = _T_170 ? timeh : _T_290; // @[Lookup.scala 11:37]
  assign _T_292 = _T_166 ? cycleh : _T_291; // @[Lookup.scala 11:37]
  assign _T_293 = _T_162 ? instret : _T_292; // @[Lookup.scala 11:37]
  assign _T_294 = _T_158 ? time$ : _T_293; // @[Lookup.scala 11:37]
  assign _T_295 = _T_154 ? cycle : _T_294; // @[Lookup.scala 11:37]
  assign _T_296 = csr_addr[9:8]; // @[CSR.scala 204:27]
  assign privValid = _T_296 <= PRV; // @[CSR.scala 204:34]
  assign privInst = io_cmd == 3'h4; // @[CSR.scala 205:26]
  assign _T_297 = csr_addr[0]; // @[CSR.scala 206:40]
  assign _T_299 = _T_297 == 1'h0; // @[CSR.scala 206:31]
  assign _T_300 = privInst & _T_299; // @[CSR.scala 206:28]
  assign _T_301 = csr_addr[8]; // @[CSR.scala 206:56]
  assign _T_303 = _T_301 == 1'h0; // @[CSR.scala 206:47]
  assign isEcall = _T_300 & _T_303; // @[CSR.scala 206:44]
  assign _T_305 = privInst & _T_297; // @[CSR.scala 207:28]
  assign isEbreak = _T_305 & _T_303; // @[CSR.scala 207:44]
  assign isEret = _T_300 & _T_301; // @[CSR.scala 208:44]
  assign _T_430 = _T_154 | _T_158; // @[CSR.scala 209:61]
  assign _T_431 = _T_430 | _T_162; // @[CSR.scala 209:61]
  assign _T_432 = _T_431 | _T_166; // @[CSR.scala 209:61]
  assign _T_433 = _T_432 | _T_170; // @[CSR.scala 209:61]
  assign _T_434 = _T_433 | _T_174; // @[CSR.scala 209:61]
  assign _T_435 = _T_434 | _T_178; // @[CSR.scala 209:61]
  assign _T_436 = _T_435 | _T_182; // @[CSR.scala 209:61]
  assign _T_437 = _T_436 | _T_186; // @[CSR.scala 209:61]
  assign _T_438 = _T_437 | _T_190; // @[CSR.scala 209:61]
  assign _T_439 = _T_438 | _T_194; // @[CSR.scala 209:61]
  assign _T_440 = _T_439 | _T_198; // @[CSR.scala 209:61]
  assign _T_441 = _T_440 | _T_202; // @[CSR.scala 209:61]
  assign _T_442 = _T_441 | _T_206; // @[CSR.scala 209:61]
  assign _T_443 = _T_442 | _T_210; // @[CSR.scala 209:61]
  assign _T_444 = _T_443 | _T_214; // @[CSR.scala 209:61]
  assign _T_445 = _T_444 | _T_218; // @[CSR.scala 209:61]
  assign _T_446 = _T_445 | _T_222; // @[CSR.scala 209:61]
  assign _T_447 = _T_446 | _T_226; // @[CSR.scala 209:61]
  assign _T_448 = _T_447 | _T_230; // @[CSR.scala 209:61]
  assign _T_449 = _T_448 | _T_234; // @[CSR.scala 209:61]
  assign _T_450 = _T_449 | _T_238; // @[CSR.scala 209:61]
  assign _T_451 = _T_450 | _T_242; // @[CSR.scala 209:61]
  assign _T_452 = _T_451 | _T_246; // @[CSR.scala 209:61]
  assign _T_453 = _T_452 | _T_250; // @[CSR.scala 209:61]
  assign _T_454 = _T_453 | _T_254; // @[CSR.scala 209:61]
  assign _T_455 = _T_454 | _T_258; // @[CSR.scala 209:61]
  assign _T_456 = _T_455 | _T_262; // @[CSR.scala 209:61]
  assign csrValid = _T_456 | _T_266; // @[CSR.scala 209:61]
  assign _T_457 = csr_addr[11:10]; // @[CSR.scala 210:27]
  assign _T_458 = ~ _T_457; // @[CSR.scala 210:36]
  assign _T_460 = _T_458 == 2'h0; // @[CSR.scala 210:36]
  assign _T_461 = csr_addr == 12'h301; // @[CSR.scala 210:53]
  assign _T_462 = _T_460 | _T_461; // @[CSR.scala 210:41]
  assign _T_463 = csr_addr == 12'h302; // @[CSR.scala 210:79]
  assign csrRO = _T_462 | _T_463; // @[CSR.scala 210:67]
  assign _T_464 = io_cmd == 3'h1; // @[CSR.scala 211:26]
  assign _T_465 = io_cmd[1]; // @[CSR.scala 211:45]
  assign _T_467 = rs1_addr != 5'h0; // @[CSR.scala 211:61]
  assign _T_468 = _T_465 & _T_467; // @[CSR.scala 211:49]
  assign wen = _T_464 | _T_468; // @[CSR.scala 211:36]
  assign _T_470 = io_out | io_in; // @[CSR.scala 214:22]
  assign _T_471 = ~ io_in; // @[CSR.scala 215:24]
  assign _T_472 = io_out & _T_471; // @[CSR.scala 215:22]
  assign _T_473 = 3'h3 == io_cmd; // @[Mux.scala 46:19]
  assign _T_474 = _T_473 ? _T_472 : 32'h0; // @[Mux.scala 46:16]
  assign _T_475 = 3'h2 == io_cmd; // @[Mux.scala 46:19]
  assign _T_476 = _T_475 ? _T_470 : _T_474; // @[Mux.scala 46:16]
  assign _T_477 = 3'h1 == io_cmd; // @[Mux.scala 46:19]
  assign wdata = _T_477 ? io_in : _T_476; // @[Mux.scala 46:16]
  assign _T_478 = io_addr[1]; // @[CSR.scala 217:44]
  assign iaddrInvalid = io_pc_check & _T_478; // @[CSR.scala 217:34]
  assign _T_533 = io_addr[1:0]; // @[CSR.scala 219:29]
  assign _T_535 = _T_533 != 2'h0; // @[CSR.scala 219:36]
  assign _T_536 = io_addr[0]; // @[CSR.scala 219:65]
  assign _T_538 = 3'h4 == io_ld_type; // @[Mux.scala 46:19]
  assign _T_539 = _T_538 ? _T_536 : 1'h0; // @[Mux.scala 46:16]
  assign _T_540 = 3'h2 == io_ld_type; // @[Mux.scala 46:19]
  assign _T_541 = _T_540 ? _T_536 : _T_539; // @[Mux.scala 46:16]
  assign _T_542 = 3'h1 == io_ld_type; // @[Mux.scala 46:19]
  assign laddrInvalid = _T_542 ? _T_535 : _T_541; // @[Mux.scala 46:16]
  assign _T_548 = 2'h2 == io_st_type; // @[Mux.scala 46:19]
  assign _T_549 = _T_548 ? _T_536 : 1'h0; // @[Mux.scala 46:16]
  assign _T_550 = 2'h1 == io_st_type; // @[Mux.scala 46:19]
  assign saddrInvalid = _T_550 ? _T_535 : _T_549; // @[Mux.scala 46:16]
  assign _T_551 = io_illegal | iaddrInvalid; // @[CSR.scala 222:25]
  assign _T_552 = _T_551 | laddrInvalid; // @[CSR.scala 222:41]
  assign _T_553 = _T_552 | saddrInvalid; // @[CSR.scala 222:57]
  assign _T_554 = io_cmd[1:0]; // @[CSR.scala 223:20]
  assign _T_556 = _T_554 != 2'h0; // @[CSR.scala 223:27]
  assign _T_558 = csrValid == 1'h0; // @[CSR.scala 223:35]
  assign _T_560 = privValid == 1'h0; // @[CSR.scala 223:48]
  assign _T_561 = _T_558 | _T_560; // @[CSR.scala 223:45]
  assign _T_562 = _T_556 & _T_561; // @[CSR.scala 223:31]
  assign _T_563 = _T_553 | _T_562; // @[CSR.scala 222:73]
  assign _T_564 = wen & csrRO; // @[CSR.scala 223:67]
  assign _T_565 = _T_563 | _T_564; // @[CSR.scala 223:60]
  assign _T_568 = privInst & _T_560; // @[CSR.scala 224:24]
  assign _T_569 = _T_565 | _T_568; // @[CSR.scala 223:76]
  assign _T_570 = _T_569 | isEcall; // @[CSR.scala 224:39]
  assign _T_571 = _T_570 | isEbreak; // @[CSR.scala 224:50]
  assign _GEN_260 = {{6'd0}, PRV}; // @[CSR.scala 225:27]
  assign _T_572 = _GEN_260 << 6; // @[CSR.scala 225:27]
  assign _GEN_261 = {{24'd0}, _T_572}; // @[CSR.scala 225:20]
  assign _T_573 = 32'h100 + _GEN_261; // @[CSR.scala 225:20]
  assign _T_574 = _T_573[31:0]; // @[CSR.scala 225:20]
  assign _T_576 = time$ + 32'h1; // @[CSR.scala 229:16]
  assign _T_577 = _T_576[31:0]; // @[CSR.scala 229:16]
  assign _T_578 = ~ time$; // @[CSR.scala 230:13]
  assign _T_580 = _T_578 == 32'h0; // @[CSR.scala 230:13]
  assign _T_582 = timeh + 32'h1; // @[CSR.scala 230:36]
  assign _T_583 = _T_582[31:0]; // @[CSR.scala 230:36]
  assign _GEN_1 = _T_580 ? _T_583 : timeh; // @[CSR.scala 230:19]
  assign _T_585 = cycle + 32'h1; // @[CSR.scala 231:18]
  assign _T_586 = _T_585[31:0]; // @[CSR.scala 231:18]
  assign _T_587 = ~ cycle; // @[CSR.scala 232:14]
  assign _T_589 = _T_587 == 32'h0; // @[CSR.scala 232:14]
  assign _T_591 = cycleh + 32'h1; // @[CSR.scala 232:39]
  assign _T_592 = _T_591[31:0]; // @[CSR.scala 232:39]
  assign _GEN_2 = _T_589 ? _T_592 : cycleh; // @[CSR.scala 232:20]
  assign _T_594 = io_inst != 32'h13; // @[CSR.scala 233:27]
  assign _T_596 = io_expt == 1'h0; // @[CSR.scala 233:52]
  assign _T_597 = _T_596 | isEcall; // @[CSR.scala 233:61]
  assign _T_598 = _T_597 | isEbreak; // @[CSR.scala 233:72]
  assign _T_599 = _T_594 & _T_598; // @[CSR.scala 233:48]
  assign _T_601 = io_stall == 1'h0; // @[CSR.scala 233:88]
  assign isInstRet = _T_599 & _T_601; // @[CSR.scala 233:85]
  assign _T_603 = instret + 32'h1; // @[CSR.scala 234:40]
  assign _T_604 = _T_603[31:0]; // @[CSR.scala 234:40]
  assign _GEN_3 = isInstRet ? _T_604 : instret; // @[CSR.scala 234:19]
  assign _T_605 = ~ instret; // @[CSR.scala 235:29]
  assign _T_607 = _T_605 == 32'h0; // @[CSR.scala 235:29]
  assign _T_608 = isInstRet & _T_607; // @[CSR.scala 235:18]
  assign _T_610 = instreth + 32'h1; // @[CSR.scala 235:58]
  assign _T_611 = _T_610[31:0]; // @[CSR.scala 235:58]
  assign _GEN_4 = _T_608 ? _T_611 : instreth; // @[CSR.scala 235:35]
  assign _T_614 = io_pc[31:2]; // @[CSR.scala 239:23]
  assign _GEN_262 = {{2'd0}, _T_614}; // @[CSR.scala 239:28]
  assign _T_615 = _GEN_262 << 2; // @[CSR.scala 239:28]
  assign _GEN_263 = {{2'd0}, PRV}; // @[CSR.scala 243:47]
  assign _T_622 = 4'h8 + _GEN_263; // @[CSR.scala 243:47]
  assign _T_623 = _T_622[3:0]; // @[CSR.scala 243:47]
  assign _T_624 = isEbreak ? 2'h3 : 2'h2; // @[CSR.scala 244:20]
  assign _T_625 = isEcall ? _T_623 : {{2'd0}, _T_624}; // @[CSR.scala 243:20]
  assign _T_626 = saddrInvalid ? 4'h6 : _T_625; // @[CSR.scala 242:20]
  assign _T_627 = laddrInvalid ? 4'h4 : _T_626; // @[CSR.scala 241:20]
  assign _T_628 = iaddrInvalid ? 4'h0 : _T_627; // @[CSR.scala 240:20]
  assign _T_630 = iaddrInvalid | laddrInvalid; // @[CSR.scala 249:25]
  assign _T_631 = _T_630 | saddrInvalid; // @[CSR.scala 249:41]
  assign _GEN_5 = _T_631 ? io_addr : mbadaddr; // @[CSR.scala 249:58]
  assign _T_633 = csr_addr == 12'h300; // @[CSR.scala 256:21]
  assign _T_634 = wdata[5:4]; // @[CSR.scala 257:22]
  assign _T_635 = wdata[3]; // @[CSR.scala 258:22]
  assign _T_636 = wdata[2:1]; // @[CSR.scala 259:22]
  assign _T_637 = wdata[0]; // @[CSR.scala 260:22]
  assign _T_638 = csr_addr == 12'h344; // @[CSR.scala 262:26]
  assign _T_639 = wdata[7]; // @[CSR.scala 263:22]
  assign _T_641 = csr_addr == 12'h304; // @[CSR.scala 266:26]
  assign _T_644 = csr_addr == 12'h701; // @[CSR.scala 270:26]
  assign _T_645 = csr_addr == 12'h741; // @[CSR.scala 271:26]
  assign _T_646 = csr_addr == 12'h321; // @[CSR.scala 272:26]
  assign _T_647 = csr_addr == 12'h340; // @[CSR.scala 273:26]
  assign _T_648 = csr_addr == 12'h341; // @[CSR.scala 274:26]
  assign _T_650 = wdata >> 2'h2; // @[CSR.scala 274:56]
  assign _GEN_264 = {{3'd0}, _T_650}; // @[CSR.scala 274:63]
  assign _T_652 = _GEN_264 << 2'h2; // @[CSR.scala 274:63]
  assign _T_653 = csr_addr == 12'h342; // @[CSR.scala 275:26]
  assign _T_655 = wdata & 32'h8000000f; // @[CSR.scala 275:60]
  assign _T_656 = csr_addr == 12'h343; // @[CSR.scala 276:26]
  assign _T_657 = csr_addr == 12'h780; // @[CSR.scala 277:26]
  assign _T_658 = csr_addr == 12'h781; // @[CSR.scala 278:26]
  assign _T_659 = csr_addr == 12'h900; // @[CSR.scala 279:26]
  assign _T_660 = csr_addr == 12'h901; // @[CSR.scala 280:26]
  assign _T_661 = csr_addr == 12'h902; // @[CSR.scala 281:26]
  assign _T_662 = csr_addr == 12'h980; // @[CSR.scala 282:26]
  assign _T_663 = csr_addr == 12'h981; // @[CSR.scala 283:26]
  assign _T_664 = csr_addr == 12'h982; // @[CSR.scala 284:26]
  assign _GEN_6 = _T_664 ? wdata : _GEN_4; // @[CSR.scala 284:45]
  assign _GEN_7 = _T_663 ? wdata : _GEN_1; // @[CSR.scala 283:42]
  assign _GEN_8 = _T_663 ? _GEN_4 : _GEN_6; // @[CSR.scala 283:42]
  assign _GEN_9 = _T_662 ? wdata : _GEN_2; // @[CSR.scala 282:43]
  assign _GEN_10 = _T_662 ? _GEN_1 : _GEN_7; // @[CSR.scala 282:43]
  assign _GEN_11 = _T_662 ? _GEN_4 : _GEN_8; // @[CSR.scala 282:43]
  assign _GEN_12 = _T_661 ? wdata : _GEN_3; // @[CSR.scala 281:44]
  assign _GEN_13 = _T_661 ? _GEN_2 : _GEN_9; // @[CSR.scala 281:44]
  assign _GEN_14 = _T_661 ? _GEN_1 : _GEN_10; // @[CSR.scala 281:44]
  assign _GEN_15 = _T_661 ? _GEN_4 : _GEN_11; // @[CSR.scala 281:44]
  assign _GEN_16 = _T_660 ? wdata : _T_577; // @[CSR.scala 280:41]
  assign _GEN_17 = _T_660 ? _GEN_3 : _GEN_12; // @[CSR.scala 280:41]
  assign _GEN_18 = _T_660 ? _GEN_2 : _GEN_13; // @[CSR.scala 280:41]
  assign _GEN_19 = _T_660 ? _GEN_1 : _GEN_14; // @[CSR.scala 280:41]
  assign _GEN_20 = _T_660 ? _GEN_4 : _GEN_15; // @[CSR.scala 280:41]
  assign _GEN_21 = _T_659 ? wdata : _T_586; // @[CSR.scala 279:42]
  assign _GEN_22 = _T_659 ? _T_577 : _GEN_16; // @[CSR.scala 279:42]
  assign _GEN_23 = _T_659 ? _GEN_3 : _GEN_17; // @[CSR.scala 279:42]
  assign _GEN_24 = _T_659 ? _GEN_2 : _GEN_18; // @[CSR.scala 279:42]
  assign _GEN_25 = _T_659 ? _GEN_1 : _GEN_19; // @[CSR.scala 279:42]
  assign _GEN_26 = _T_659 ? _GEN_4 : _GEN_20; // @[CSR.scala 279:42]
  assign _GEN_27 = _T_658 ? wdata : mfromhost; // @[CSR.scala 278:45]
  assign _GEN_28 = _T_658 ? _T_586 : _GEN_21; // @[CSR.scala 278:45]
  assign _GEN_29 = _T_658 ? _T_577 : _GEN_22; // @[CSR.scala 278:45]
  assign _GEN_30 = _T_658 ? _GEN_3 : _GEN_23; // @[CSR.scala 278:45]
  assign _GEN_31 = _T_658 ? _GEN_2 : _GEN_24; // @[CSR.scala 278:45]
  assign _GEN_32 = _T_658 ? _GEN_1 : _GEN_25; // @[CSR.scala 278:45]
  assign _GEN_33 = _T_658 ? _GEN_4 : _GEN_26; // @[CSR.scala 278:45]
  assign _GEN_34 = _T_657 ? wdata : mtohost; // @[CSR.scala 277:43]
  assign _GEN_35 = _T_657 ? mfromhost : _GEN_27; // @[CSR.scala 277:43]
  assign _GEN_36 = _T_657 ? _T_586 : _GEN_28; // @[CSR.scala 277:43]
  assign _GEN_37 = _T_657 ? _T_577 : _GEN_29; // @[CSR.scala 277:43]
  assign _GEN_38 = _T_657 ? _GEN_3 : _GEN_30; // @[CSR.scala 277:43]
  assign _GEN_39 = _T_657 ? _GEN_2 : _GEN_31; // @[CSR.scala 277:43]
  assign _GEN_40 = _T_657 ? _GEN_1 : _GEN_32; // @[CSR.scala 277:43]
  assign _GEN_41 = _T_657 ? _GEN_4 : _GEN_33; // @[CSR.scala 277:43]
  assign _GEN_42 = _T_656 ? wdata : mbadaddr; // @[CSR.scala 276:44]
  assign _GEN_43 = _T_656 ? mtohost : _GEN_34; // @[CSR.scala 276:44]
  assign _GEN_44 = _T_656 ? mfromhost : _GEN_35; // @[CSR.scala 276:44]
  assign _GEN_45 = _T_656 ? _T_586 : _GEN_36; // @[CSR.scala 276:44]
  assign _GEN_46 = _T_656 ? _T_577 : _GEN_37; // @[CSR.scala 276:44]
  assign _GEN_47 = _T_656 ? _GEN_3 : _GEN_38; // @[CSR.scala 276:44]
  assign _GEN_48 = _T_656 ? _GEN_2 : _GEN_39; // @[CSR.scala 276:44]
  assign _GEN_49 = _T_656 ? _GEN_1 : _GEN_40; // @[CSR.scala 276:44]
  assign _GEN_50 = _T_656 ? _GEN_4 : _GEN_41; // @[CSR.scala 276:44]
  assign _GEN_51 = _T_653 ? _T_655 : mcause; // @[CSR.scala 275:42]
  assign _GEN_52 = _T_653 ? mbadaddr : _GEN_42; // @[CSR.scala 275:42]
  assign _GEN_53 = _T_653 ? mtohost : _GEN_43; // @[CSR.scala 275:42]
  assign _GEN_54 = _T_653 ? mfromhost : _GEN_44; // @[CSR.scala 275:42]
  assign _GEN_55 = _T_653 ? _T_586 : _GEN_45; // @[CSR.scala 275:42]
  assign _GEN_56 = _T_653 ? _T_577 : _GEN_46; // @[CSR.scala 275:42]
  assign _GEN_57 = _T_653 ? _GEN_3 : _GEN_47; // @[CSR.scala 275:42]
  assign _GEN_58 = _T_653 ? _GEN_2 : _GEN_48; // @[CSR.scala 275:42]
  assign _GEN_59 = _T_653 ? _GEN_1 : _GEN_49; // @[CSR.scala 275:42]
  assign _GEN_60 = _T_653 ? _GEN_4 : _GEN_50; // @[CSR.scala 275:42]
  assign _GEN_61 = _T_648 ? _T_652 : {{3'd0}, mepc}; // @[CSR.scala 274:40]
  assign _GEN_62 = _T_648 ? mcause : _GEN_51; // @[CSR.scala 274:40]
  assign _GEN_63 = _T_648 ? mbadaddr : _GEN_52; // @[CSR.scala 274:40]
  assign _GEN_64 = _T_648 ? mtohost : _GEN_53; // @[CSR.scala 274:40]
  assign _GEN_65 = _T_648 ? mfromhost : _GEN_54; // @[CSR.scala 274:40]
  assign _GEN_66 = _T_648 ? _T_586 : _GEN_55; // @[CSR.scala 274:40]
  assign _GEN_67 = _T_648 ? _T_577 : _GEN_56; // @[CSR.scala 274:40]
  assign _GEN_68 = _T_648 ? _GEN_3 : _GEN_57; // @[CSR.scala 274:40]
  assign _GEN_69 = _T_648 ? _GEN_2 : _GEN_58; // @[CSR.scala 274:40]
  assign _GEN_70 = _T_648 ? _GEN_1 : _GEN_59; // @[CSR.scala 274:40]
  assign _GEN_71 = _T_648 ? _GEN_4 : _GEN_60; // @[CSR.scala 274:40]
  assign _GEN_72 = _T_647 ? wdata : mscratch; // @[CSR.scala 273:44]
  assign _GEN_73 = _T_647 ? {{3'd0}, mepc} : _GEN_61; // @[CSR.scala 273:44]
  assign _GEN_74 = _T_647 ? mcause : _GEN_62; // @[CSR.scala 273:44]
  assign _GEN_75 = _T_647 ? mbadaddr : _GEN_63; // @[CSR.scala 273:44]
  assign _GEN_76 = _T_647 ? mtohost : _GEN_64; // @[CSR.scala 273:44]
  assign _GEN_77 = _T_647 ? mfromhost : _GEN_65; // @[CSR.scala 273:44]
  assign _GEN_78 = _T_647 ? _T_586 : _GEN_66; // @[CSR.scala 273:44]
  assign _GEN_79 = _T_647 ? _T_577 : _GEN_67; // @[CSR.scala 273:44]
  assign _GEN_80 = _T_647 ? _GEN_3 : _GEN_68; // @[CSR.scala 273:44]
  assign _GEN_81 = _T_647 ? _GEN_2 : _GEN_69; // @[CSR.scala 273:44]
  assign _GEN_82 = _T_647 ? _GEN_1 : _GEN_70; // @[CSR.scala 273:44]
  assign _GEN_83 = _T_647 ? _GEN_4 : _GEN_71; // @[CSR.scala 273:44]
  assign _GEN_84 = _T_646 ? wdata : mtimecmp; // @[CSR.scala 272:44]
  assign _GEN_85 = _T_646 ? mscratch : _GEN_72; // @[CSR.scala 272:44]
  assign _GEN_86 = _T_646 ? {{3'd0}, mepc} : _GEN_73; // @[CSR.scala 272:44]
  assign _GEN_87 = _T_646 ? mcause : _GEN_74; // @[CSR.scala 272:44]
  assign _GEN_88 = _T_646 ? mbadaddr : _GEN_75; // @[CSR.scala 272:44]
  assign _GEN_89 = _T_646 ? mtohost : _GEN_76; // @[CSR.scala 272:44]
  assign _GEN_90 = _T_646 ? mfromhost : _GEN_77; // @[CSR.scala 272:44]
  assign _GEN_91 = _T_646 ? _T_586 : _GEN_78; // @[CSR.scala 272:44]
  assign _GEN_92 = _T_646 ? _T_577 : _GEN_79; // @[CSR.scala 272:44]
  assign _GEN_93 = _T_646 ? _GEN_3 : _GEN_80; // @[CSR.scala 272:44]
  assign _GEN_94 = _T_646 ? _GEN_2 : _GEN_81; // @[CSR.scala 272:44]
  assign _GEN_95 = _T_646 ? _GEN_1 : _GEN_82; // @[CSR.scala 272:44]
  assign _GEN_96 = _T_646 ? _GEN_4 : _GEN_83; // @[CSR.scala 272:44]
  assign _GEN_97 = _T_645 ? wdata : _GEN_95; // @[CSR.scala 271:42]
  assign _GEN_98 = _T_645 ? mtimecmp : _GEN_84; // @[CSR.scala 271:42]
  assign _GEN_99 = _T_645 ? mscratch : _GEN_85; // @[CSR.scala 271:42]
  assign _GEN_100 = _T_645 ? {{3'd0}, mepc} : _GEN_86; // @[CSR.scala 271:42]
  assign _GEN_101 = _T_645 ? mcause : _GEN_87; // @[CSR.scala 271:42]
  assign _GEN_102 = _T_645 ? mbadaddr : _GEN_88; // @[CSR.scala 271:42]
  assign _GEN_103 = _T_645 ? mtohost : _GEN_89; // @[CSR.scala 271:42]
  assign _GEN_104 = _T_645 ? mfromhost : _GEN_90; // @[CSR.scala 271:42]
  assign _GEN_105 = _T_645 ? _T_586 : _GEN_91; // @[CSR.scala 271:42]
  assign _GEN_106 = _T_645 ? _T_577 : _GEN_92; // @[CSR.scala 271:42]
  assign _GEN_107 = _T_645 ? _GEN_3 : _GEN_93; // @[CSR.scala 271:42]
  assign _GEN_108 = _T_645 ? _GEN_2 : _GEN_94; // @[CSR.scala 271:42]
  assign _GEN_109 = _T_645 ? _GEN_4 : _GEN_96; // @[CSR.scala 271:42]
  assign _GEN_110 = _T_644 ? wdata : _GEN_106; // @[CSR.scala 270:41]
  assign _GEN_111 = _T_644 ? _GEN_1 : _GEN_97; // @[CSR.scala 270:41]
  assign _GEN_112 = _T_644 ? mtimecmp : _GEN_98; // @[CSR.scala 270:41]
  assign _GEN_113 = _T_644 ? mscratch : _GEN_99; // @[CSR.scala 270:41]
  assign _GEN_114 = _T_644 ? {{3'd0}, mepc} : _GEN_100; // @[CSR.scala 270:41]
  assign _GEN_115 = _T_644 ? mcause : _GEN_101; // @[CSR.scala 270:41]
  assign _GEN_116 = _T_644 ? mbadaddr : _GEN_102; // @[CSR.scala 270:41]
  assign _GEN_117 = _T_644 ? mtohost : _GEN_103; // @[CSR.scala 270:41]
  assign _GEN_118 = _T_644 ? mfromhost : _GEN_104; // @[CSR.scala 270:41]
  assign _GEN_119 = _T_644 ? _T_586 : _GEN_105; // @[CSR.scala 270:41]
  assign _GEN_120 = _T_644 ? _GEN_3 : _GEN_107; // @[CSR.scala 270:41]
  assign _GEN_121 = _T_644 ? _GEN_2 : _GEN_108; // @[CSR.scala 270:41]
  assign _GEN_122 = _T_644 ? _GEN_4 : _GEN_109; // @[CSR.scala 270:41]
  assign _GEN_123 = _T_641 ? _T_639 : MTIE; // @[CSR.scala 266:39]
  assign _GEN_124 = _T_641 ? _T_635 : MSIE; // @[CSR.scala 266:39]
  assign _GEN_125 = _T_641 ? _T_577 : _GEN_110; // @[CSR.scala 266:39]
  assign _GEN_126 = _T_641 ? _GEN_1 : _GEN_111; // @[CSR.scala 266:39]
  assign _GEN_127 = _T_641 ? mtimecmp : _GEN_112; // @[CSR.scala 266:39]
  assign _GEN_128 = _T_641 ? mscratch : _GEN_113; // @[CSR.scala 266:39]
  assign _GEN_129 = _T_641 ? {{3'd0}, mepc} : _GEN_114; // @[CSR.scala 266:39]
  assign _GEN_130 = _T_641 ? mcause : _GEN_115; // @[CSR.scala 266:39]
  assign _GEN_131 = _T_641 ? mbadaddr : _GEN_116; // @[CSR.scala 266:39]
  assign _GEN_132 = _T_641 ? mtohost : _GEN_117; // @[CSR.scala 266:39]
  assign _GEN_133 = _T_641 ? mfromhost : _GEN_118; // @[CSR.scala 266:39]
  assign _GEN_134 = _T_641 ? _T_586 : _GEN_119; // @[CSR.scala 266:39]
  assign _GEN_135 = _T_641 ? _GEN_3 : _GEN_120; // @[CSR.scala 266:39]
  assign _GEN_136 = _T_641 ? _GEN_2 : _GEN_121; // @[CSR.scala 266:39]
  assign _GEN_137 = _T_641 ? _GEN_4 : _GEN_122; // @[CSR.scala 266:39]
  assign _GEN_138 = _T_638 ? _T_639 : MTIP; // @[CSR.scala 262:39]
  assign _GEN_139 = _T_638 ? _T_635 : MSIP; // @[CSR.scala 262:39]
  assign _GEN_140 = _T_638 ? MTIE : _GEN_123; // @[CSR.scala 262:39]
  assign _GEN_141 = _T_638 ? MSIE : _GEN_124; // @[CSR.scala 262:39]
  assign _GEN_142 = _T_638 ? _T_577 : _GEN_125; // @[CSR.scala 262:39]
  assign _GEN_143 = _T_638 ? _GEN_1 : _GEN_126; // @[CSR.scala 262:39]
  assign _GEN_144 = _T_638 ? mtimecmp : _GEN_127; // @[CSR.scala 262:39]
  assign _GEN_145 = _T_638 ? mscratch : _GEN_128; // @[CSR.scala 262:39]
  assign _GEN_146 = _T_638 ? {{3'd0}, mepc} : _GEN_129; // @[CSR.scala 262:39]
  assign _GEN_147 = _T_638 ? mcause : _GEN_130; // @[CSR.scala 262:39]
  assign _GEN_148 = _T_638 ? mbadaddr : _GEN_131; // @[CSR.scala 262:39]
  assign _GEN_149 = _T_638 ? mtohost : _GEN_132; // @[CSR.scala 262:39]
  assign _GEN_150 = _T_638 ? mfromhost : _GEN_133; // @[CSR.scala 262:39]
  assign _GEN_151 = _T_638 ? _T_586 : _GEN_134; // @[CSR.scala 262:39]
  assign _GEN_152 = _T_638 ? _GEN_3 : _GEN_135; // @[CSR.scala 262:39]
  assign _GEN_153 = _T_638 ? _GEN_2 : _GEN_136; // @[CSR.scala 262:39]
  assign _GEN_154 = _T_638 ? _GEN_4 : _GEN_137; // @[CSR.scala 262:39]
  assign _GEN_155 = _T_633 ? _T_634 : PRV1; // @[CSR.scala 256:38]
  assign _GEN_156 = _T_633 ? _T_635 : IE1; // @[CSR.scala 256:38]
  assign _GEN_157 = _T_633 ? _T_636 : PRV; // @[CSR.scala 256:38]
  assign _GEN_158 = _T_633 ? _T_637 : IE; // @[CSR.scala 256:38]
  assign _GEN_159 = _T_633 ? MTIP : _GEN_138; // @[CSR.scala 256:38]
  assign _GEN_160 = _T_633 ? MSIP : _GEN_139; // @[CSR.scala 256:38]
  assign _GEN_161 = _T_633 ? MTIE : _GEN_140; // @[CSR.scala 256:38]
  assign _GEN_162 = _T_633 ? MSIE : _GEN_141; // @[CSR.scala 256:38]
  assign _GEN_163 = _T_633 ? _T_577 : _GEN_142; // @[CSR.scala 256:38]
  assign _GEN_164 = _T_633 ? _GEN_1 : _GEN_143; // @[CSR.scala 256:38]
  assign _GEN_165 = _T_633 ? mtimecmp : _GEN_144; // @[CSR.scala 256:38]
  assign _GEN_166 = _T_633 ? mscratch : _GEN_145; // @[CSR.scala 256:38]
  assign _GEN_167 = _T_633 ? {{3'd0}, mepc} : _GEN_146; // @[CSR.scala 256:38]
  assign _GEN_168 = _T_633 ? mcause : _GEN_147; // @[CSR.scala 256:38]
  assign _GEN_169 = _T_633 ? mbadaddr : _GEN_148; // @[CSR.scala 256:38]
  assign _GEN_170 = _T_633 ? mtohost : _GEN_149; // @[CSR.scala 256:38]
  assign _GEN_171 = _T_633 ? mfromhost : _GEN_150; // @[CSR.scala 256:38]
  assign _GEN_172 = _T_633 ? _T_586 : _GEN_151; // @[CSR.scala 256:38]
  assign _GEN_173 = _T_633 ? _GEN_3 : _GEN_152; // @[CSR.scala 256:38]
  assign _GEN_174 = _T_633 ? _GEN_2 : _GEN_153; // @[CSR.scala 256:38]
  assign _GEN_175 = _T_633 ? _GEN_4 : _GEN_154; // @[CSR.scala 256:38]
  assign _GEN_176 = wen ? _GEN_155 : PRV1; // @[CSR.scala 255:21]
  assign _GEN_177 = wen ? _GEN_156 : IE1; // @[CSR.scala 255:21]
  assign _GEN_178 = wen ? _GEN_157 : PRV; // @[CSR.scala 255:21]
  assign _GEN_179 = wen ? _GEN_158 : IE; // @[CSR.scala 255:21]
  assign _GEN_180 = wen ? _GEN_159 : MTIP; // @[CSR.scala 255:21]
  assign _GEN_181 = wen ? _GEN_160 : MSIP; // @[CSR.scala 255:21]
  assign _GEN_182 = wen ? _GEN_161 : MTIE; // @[CSR.scala 255:21]
  assign _GEN_183 = wen ? _GEN_162 : MSIE; // @[CSR.scala 255:21]
  assign _GEN_184 = wen ? _GEN_163 : _T_577; // @[CSR.scala 255:21]
  assign _GEN_185 = wen ? _GEN_164 : _GEN_1; // @[CSR.scala 255:21]
  assign _GEN_186 = wen ? _GEN_165 : mtimecmp; // @[CSR.scala 255:21]
  assign _GEN_187 = wen ? _GEN_166 : mscratch; // @[CSR.scala 255:21]
  assign _GEN_188 = wen ? _GEN_167 : {{3'd0}, mepc}; // @[CSR.scala 255:21]
  assign _GEN_189 = wen ? _GEN_168 : mcause; // @[CSR.scala 255:21]
  assign _GEN_190 = wen ? _GEN_169 : mbadaddr; // @[CSR.scala 255:21]
  assign _GEN_191 = wen ? _GEN_170 : mtohost; // @[CSR.scala 255:21]
  assign _GEN_192 = wen ? _GEN_171 : mfromhost; // @[CSR.scala 255:21]
  assign _GEN_193 = wen ? _GEN_172 : _T_586; // @[CSR.scala 255:21]
  assign _GEN_194 = wen ? _GEN_173 : _GEN_3; // @[CSR.scala 255:21]
  assign _GEN_195 = wen ? _GEN_174 : _GEN_2; // @[CSR.scala 255:21]
  assign _GEN_196 = wen ? _GEN_175 : _GEN_4; // @[CSR.scala 255:21]
  assign _GEN_197 = isEret ? PRV1 : _GEN_178; // @[CSR.scala 250:24]
  assign _GEN_198 = isEret ? IE1 : _GEN_179; // @[CSR.scala 250:24]
  assign _GEN_199 = isEret ? 2'h0 : _GEN_176; // @[CSR.scala 250:24]
  assign _GEN_200 = isEret ? 1'h1 : _GEN_177; // @[CSR.scala 250:24]
  assign _GEN_201 = isEret ? MTIP : _GEN_180; // @[CSR.scala 250:24]
  assign _GEN_202 = isEret ? MSIP : _GEN_181; // @[CSR.scala 250:24]
  assign _GEN_203 = isEret ? MTIE : _GEN_182; // @[CSR.scala 250:24]
  assign _GEN_204 = isEret ? MSIE : _GEN_183; // @[CSR.scala 250:24]
  assign _GEN_205 = isEret ? _T_577 : _GEN_184; // @[CSR.scala 250:24]
  assign _GEN_206 = isEret ? _GEN_1 : _GEN_185; // @[CSR.scala 250:24]
  assign _GEN_207 = isEret ? mtimecmp : _GEN_186; // @[CSR.scala 250:24]
  assign _GEN_208 = isEret ? mscratch : _GEN_187; // @[CSR.scala 250:24]
  assign _GEN_209 = isEret ? {{3'd0}, mepc} : _GEN_188; // @[CSR.scala 250:24]
  assign _GEN_210 = isEret ? mcause : _GEN_189; // @[CSR.scala 250:24]
  assign _GEN_211 = isEret ? mbadaddr : _GEN_190; // @[CSR.scala 250:24]
  assign _GEN_212 = isEret ? mtohost : _GEN_191; // @[CSR.scala 250:24]
  assign _GEN_213 = isEret ? mfromhost : _GEN_192; // @[CSR.scala 250:24]
  assign _GEN_214 = isEret ? _T_586 : _GEN_193; // @[CSR.scala 250:24]
  assign _GEN_215 = isEret ? _GEN_3 : _GEN_194; // @[CSR.scala 250:24]
  assign _GEN_216 = isEret ? _GEN_2 : _GEN_195; // @[CSR.scala 250:24]
  assign _GEN_217 = isEret ? _GEN_4 : _GEN_196; // @[CSR.scala 250:24]
  assign _GEN_218 = io_expt ? {{3'd0}, _T_615} : _GEN_209; // @[CSR.scala 238:19]
  assign _GEN_219 = io_expt ? {{28'd0}, _T_628} : _GEN_210; // @[CSR.scala 238:19]
  assign _GEN_220 = io_expt ? 2'h3 : _GEN_197; // @[CSR.scala 238:19]
  assign _GEN_221 = io_expt ? 1'h0 : _GEN_198; // @[CSR.scala 238:19]
  assign _GEN_222 = io_expt ? PRV : _GEN_199; // @[CSR.scala 238:19]
  assign _GEN_223 = io_expt ? IE : _GEN_200; // @[CSR.scala 238:19]
  assign _GEN_224 = io_expt ? _GEN_5 : _GEN_211; // @[CSR.scala 238:19]
  assign _GEN_225 = io_expt ? MTIP : _GEN_201; // @[CSR.scala 238:19]
  assign _GEN_226 = io_expt ? MSIP : _GEN_202; // @[CSR.scala 238:19]
  assign _GEN_227 = io_expt ? MTIE : _GEN_203; // @[CSR.scala 238:19]
  assign _GEN_228 = io_expt ? MSIE : _GEN_204; // @[CSR.scala 238:19]
  assign _GEN_229 = io_expt ? _T_577 : _GEN_205; // @[CSR.scala 238:19]
  assign _GEN_230 = io_expt ? _GEN_1 : _GEN_206; // @[CSR.scala 238:19]
  assign _GEN_231 = io_expt ? mtimecmp : _GEN_207; // @[CSR.scala 238:19]
  assign _GEN_232 = io_expt ? mscratch : _GEN_208; // @[CSR.scala 238:19]
  assign _GEN_233 = io_expt ? mtohost : _GEN_212; // @[CSR.scala 238:19]
  assign _GEN_234 = io_expt ? mfromhost : _GEN_213; // @[CSR.scala 238:19]
  assign _GEN_235 = io_expt ? _T_586 : _GEN_214; // @[CSR.scala 238:19]
  assign _GEN_236 = io_expt ? _GEN_3 : _GEN_215; // @[CSR.scala 238:19]
  assign _GEN_237 = io_expt ? _GEN_2 : _GEN_216; // @[CSR.scala 238:19]
  assign _GEN_238 = io_expt ? _GEN_4 : _GEN_217; // @[CSR.scala 238:19]
  assign _GEN_239 = _T_601 ? _GEN_218 : {{3'd0}, mepc}; // @[CSR.scala 237:19]
  assign _GEN_240 = _T_601 ? _GEN_219 : mcause; // @[CSR.scala 237:19]
  assign _GEN_241 = _T_601 ? _GEN_220 : PRV; // @[CSR.scala 237:19]
  assign _GEN_242 = _T_601 ? _GEN_221 : IE; // @[CSR.scala 237:19]
  assign _GEN_243 = _T_601 ? _GEN_222 : PRV1; // @[CSR.scala 237:19]
  assign _GEN_244 = _T_601 ? _GEN_223 : IE1; // @[CSR.scala 237:19]
  assign _GEN_245 = _T_601 ? _GEN_224 : mbadaddr; // @[CSR.scala 237:19]
  assign _GEN_246 = _T_601 ? _GEN_225 : MTIP; // @[CSR.scala 237:19]
  assign _GEN_247 = _T_601 ? _GEN_226 : MSIP; // @[CSR.scala 237:19]
  assign _GEN_248 = _T_601 ? _GEN_227 : MTIE; // @[CSR.scala 237:19]
  assign _GEN_249 = _T_601 ? _GEN_228 : MSIE; // @[CSR.scala 237:19]
  assign _GEN_250 = _T_601 ? _GEN_229 : _T_577; // @[CSR.scala 237:19]
  assign _GEN_251 = _T_601 ? _GEN_230 : _GEN_1; // @[CSR.scala 237:19]
  assign _GEN_252 = _T_601 ? _GEN_231 : mtimecmp; // @[CSR.scala 237:19]
  assign _GEN_253 = _T_601 ? _GEN_232 : mscratch; // @[CSR.scala 237:19]
  assign _GEN_254 = _T_601 ? _GEN_233 : mtohost; // @[CSR.scala 237:19]
  assign _GEN_255 = _T_601 ? _GEN_234 : mfromhost; // @[CSR.scala 237:19]
  assign _GEN_256 = _T_601 ? _GEN_235 : _T_586; // @[CSR.scala 237:19]
  assign _GEN_257 = _T_601 ? _GEN_236 : _GEN_3; // @[CSR.scala 237:19]
  assign _GEN_258 = _T_601 ? _GEN_237 : _GEN_2; // @[CSR.scala 237:19]
  assign _GEN_259 = _T_601 ? _GEN_238 : _GEN_4; // @[CSR.scala 237:19]
  assign io_out = _T_295;
  assign io_expt = _T_571;
  assign io_evec = _T_574;
  assign io_epc = mepc;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  time$ = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  timeh = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  cycle = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{$random}};
  cycleh = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{$random}};
  instret = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{$random}};
  instreth = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{$random}};
  PRV = _RAND_6[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{$random}};
  PRV1 = _RAND_7[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{$random}};
  IE = _RAND_8[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{$random}};
  IE1 = _RAND_9[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{$random}};
  MTIP = _RAND_10[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{$random}};
  MTIE = _RAND_11[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{$random}};
  MSIP = _RAND_12[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{$random}};
  MSIE = _RAND_13[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{$random}};
  mtimecmp = _RAND_14[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_15 = {1{$random}};
  mscratch = _RAND_15[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{$random}};
  mepc = _RAND_16[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_17 = {1{$random}};
  mcause = _RAND_17[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{$random}};
  mbadaddr = _RAND_18[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_19 = {1{$random}};
  mtohost = _RAND_19[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{$random}};
  mfromhost = _RAND_20[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      time$ <= 32'h0;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          time$ <= _T_577;
        end else begin
          if (isEret) begin
            time$ <= _T_577;
          end else begin
            if (wen) begin
              if (_T_633) begin
                time$ <= _T_577;
              end else begin
                if (_T_638) begin
                  time$ <= _T_577;
                end else begin
                  if (_T_641) begin
                    time$ <= _T_577;
                  end else begin
                    if (_T_644) begin
                      if (_T_477) begin
                        time$ <= io_in;
                      end else begin
                        if (_T_475) begin
                          time$ <= _T_470;
                        end else begin
                          if (_T_473) begin
                            time$ <= _T_472;
                          end else begin
                            time$ <= 32'h0;
                          end
                        end
                      end
                    end else begin
                      if (_T_645) begin
                        time$ <= _T_577;
                      end else begin
                        if (_T_646) begin
                          time$ <= _T_577;
                        end else begin
                          if (_T_647) begin
                            time$ <= _T_577;
                          end else begin
                            if (_T_648) begin
                              time$ <= _T_577;
                            end else begin
                              if (_T_653) begin
                                time$ <= _T_577;
                              end else begin
                                if (_T_656) begin
                                  time$ <= _T_577;
                                end else begin
                                  if (_T_657) begin
                                    time$ <= _T_577;
                                  end else begin
                                    if (_T_658) begin
                                      time$ <= _T_577;
                                    end else begin
                                      if (_T_659) begin
                                        time$ <= _T_577;
                                      end else begin
                                        if (_T_660) begin
                                          if (_T_477) begin
                                            time$ <= io_in;
                                          end else begin
                                            if (_T_475) begin
                                              time$ <= _T_470;
                                            end else begin
                                              if (_T_473) begin
                                                time$ <= _T_472;
                                              end else begin
                                                time$ <= 32'h0;
                                              end
                                            end
                                          end
                                        end else begin
                                          time$ <= _T_577;
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end else begin
              time$ <= _T_577;
            end
          end
        end
      end else begin
        time$ <= _T_577;
      end
    end
    if (reset) begin
      timeh <= 32'h0;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          if (_T_580) begin
            timeh <= _T_583;
          end
        end else begin
          if (isEret) begin
            if (_T_580) begin
              timeh <= _T_583;
            end
          end else begin
            if (wen) begin
              if (_T_633) begin
                if (_T_580) begin
                  timeh <= _T_583;
                end
              end else begin
                if (_T_638) begin
                  if (_T_580) begin
                    timeh <= _T_583;
                  end
                end else begin
                  if (_T_641) begin
                    timeh <= _GEN_1;
                  end else begin
                    if (_T_644) begin
                      timeh <= _GEN_1;
                    end else begin
                      if (_T_645) begin
                        if (_T_477) begin
                          timeh <= io_in;
                        end else begin
                          if (_T_475) begin
                            timeh <= _T_470;
                          end else begin
                            if (_T_473) begin
                              timeh <= _T_472;
                            end else begin
                              timeh <= 32'h0;
                            end
                          end
                        end
                      end else begin
                        if (_T_646) begin
                          timeh <= _GEN_1;
                        end else begin
                          if (_T_647) begin
                            timeh <= _GEN_1;
                          end else begin
                            if (_T_648) begin
                              timeh <= _GEN_1;
                            end else begin
                              if (_T_653) begin
                                timeh <= _GEN_1;
                              end else begin
                                if (_T_656) begin
                                  timeh <= _GEN_1;
                                end else begin
                                  if (_T_657) begin
                                    timeh <= _GEN_1;
                                  end else begin
                                    if (_T_658) begin
                                      timeh <= _GEN_1;
                                    end else begin
                                      if (_T_659) begin
                                        timeh <= _GEN_1;
                                      end else begin
                                        if (_T_660) begin
                                          timeh <= _GEN_1;
                                        end else begin
                                          if (_T_661) begin
                                            timeh <= _GEN_1;
                                          end else begin
                                            if (_T_662) begin
                                              timeh <= _GEN_1;
                                            end else begin
                                              if (_T_663) begin
                                                if (_T_477) begin
                                                  timeh <= io_in;
                                                end else begin
                                                  if (_T_475) begin
                                                    timeh <= _T_470;
                                                  end else begin
                                                    if (_T_473) begin
                                                      timeh <= _T_472;
                                                    end else begin
                                                      timeh <= 32'h0;
                                                    end
                                                  end
                                                end
                                              end else begin
                                                timeh <= _GEN_1;
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end else begin
              timeh <= _GEN_1;
            end
          end
        end
      end else begin
        timeh <= _GEN_1;
      end
    end
    if (reset) begin
      cycle <= 32'h0;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          cycle <= _T_586;
        end else begin
          if (isEret) begin
            cycle <= _T_586;
          end else begin
            if (wen) begin
              if (_T_633) begin
                cycle <= _T_586;
              end else begin
                if (_T_638) begin
                  cycle <= _T_586;
                end else begin
                  if (_T_641) begin
                    cycle <= _T_586;
                  end else begin
                    if (_T_644) begin
                      cycle <= _T_586;
                    end else begin
                      if (_T_645) begin
                        cycle <= _T_586;
                      end else begin
                        if (_T_646) begin
                          cycle <= _T_586;
                        end else begin
                          if (_T_647) begin
                            cycle <= _T_586;
                          end else begin
                            if (_T_648) begin
                              cycle <= _T_586;
                            end else begin
                              if (_T_653) begin
                                cycle <= _T_586;
                              end else begin
                                if (_T_656) begin
                                  cycle <= _T_586;
                                end else begin
                                  if (_T_657) begin
                                    cycle <= _T_586;
                                  end else begin
                                    if (_T_658) begin
                                      cycle <= _T_586;
                                    end else begin
                                      if (_T_659) begin
                                        if (_T_477) begin
                                          cycle <= io_in;
                                        end else begin
                                          if (_T_475) begin
                                            cycle <= _T_470;
                                          end else begin
                                            if (_T_473) begin
                                              cycle <= _T_472;
                                            end else begin
                                              cycle <= 32'h0;
                                            end
                                          end
                                        end
                                      end else begin
                                        cycle <= _T_586;
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end else begin
              cycle <= _T_586;
            end
          end
        end
      end else begin
        cycle <= _T_586;
      end
    end
    if (reset) begin
      cycleh <= 32'h0;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          if (_T_589) begin
            cycleh <= _T_592;
          end
        end else begin
          if (isEret) begin
            if (_T_589) begin
              cycleh <= _T_592;
            end
          end else begin
            if (wen) begin
              if (_T_633) begin
                if (_T_589) begin
                  cycleh <= _T_592;
                end
              end else begin
                if (_T_638) begin
                  if (_T_589) begin
                    cycleh <= _T_592;
                  end
                end else begin
                  if (_T_641) begin
                    cycleh <= _GEN_2;
                  end else begin
                    if (_T_644) begin
                      cycleh <= _GEN_2;
                    end else begin
                      if (_T_645) begin
                        cycleh <= _GEN_2;
                      end else begin
                        if (_T_646) begin
                          cycleh <= _GEN_2;
                        end else begin
                          if (_T_647) begin
                            cycleh <= _GEN_2;
                          end else begin
                            if (_T_648) begin
                              cycleh <= _GEN_2;
                            end else begin
                              if (_T_653) begin
                                cycleh <= _GEN_2;
                              end else begin
                                if (_T_656) begin
                                  cycleh <= _GEN_2;
                                end else begin
                                  if (_T_657) begin
                                    cycleh <= _GEN_2;
                                  end else begin
                                    if (_T_658) begin
                                      cycleh <= _GEN_2;
                                    end else begin
                                      if (_T_659) begin
                                        cycleh <= _GEN_2;
                                      end else begin
                                        if (_T_660) begin
                                          cycleh <= _GEN_2;
                                        end else begin
                                          if (_T_661) begin
                                            cycleh <= _GEN_2;
                                          end else begin
                                            if (_T_662) begin
                                              if (_T_477) begin
                                                cycleh <= io_in;
                                              end else begin
                                                if (_T_475) begin
                                                  cycleh <= _T_470;
                                                end else begin
                                                  if (_T_473) begin
                                                    cycleh <= _T_472;
                                                  end else begin
                                                    cycleh <= 32'h0;
                                                  end
                                                end
                                              end
                                            end else begin
                                              cycleh <= _GEN_2;
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end else begin
              cycleh <= _GEN_2;
            end
          end
        end
      end else begin
        cycleh <= _GEN_2;
      end
    end
    if (reset) begin
      instret <= 32'h0;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          if (isInstRet) begin
            instret <= _T_604;
          end
        end else begin
          if (isEret) begin
            if (isInstRet) begin
              instret <= _T_604;
            end
          end else begin
            if (wen) begin
              if (_T_633) begin
                if (isInstRet) begin
                  instret <= _T_604;
                end
              end else begin
                if (_T_638) begin
                  if (isInstRet) begin
                    instret <= _T_604;
                  end
                end else begin
                  if (_T_641) begin
                    instret <= _GEN_3;
                  end else begin
                    if (_T_644) begin
                      instret <= _GEN_3;
                    end else begin
                      if (_T_645) begin
                        instret <= _GEN_3;
                      end else begin
                        if (_T_646) begin
                          instret <= _GEN_3;
                        end else begin
                          if (_T_647) begin
                            instret <= _GEN_3;
                          end else begin
                            if (_T_648) begin
                              instret <= _GEN_3;
                            end else begin
                              if (_T_653) begin
                                instret <= _GEN_3;
                              end else begin
                                if (_T_656) begin
                                  instret <= _GEN_3;
                                end else begin
                                  if (_T_657) begin
                                    instret <= _GEN_3;
                                  end else begin
                                    if (_T_658) begin
                                      instret <= _GEN_3;
                                    end else begin
                                      if (_T_659) begin
                                        instret <= _GEN_3;
                                      end else begin
                                        if (_T_660) begin
                                          instret <= _GEN_3;
                                        end else begin
                                          if (_T_661) begin
                                            if (_T_477) begin
                                              instret <= io_in;
                                            end else begin
                                              if (_T_475) begin
                                                instret <= _T_470;
                                              end else begin
                                                if (_T_473) begin
                                                  instret <= _T_472;
                                                end else begin
                                                  instret <= 32'h0;
                                                end
                                              end
                                            end
                                          end else begin
                                            instret <= _GEN_3;
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end else begin
              instret <= _GEN_3;
            end
          end
        end
      end else begin
        instret <= _GEN_3;
      end
    end
    if (reset) begin
      instreth <= 32'h0;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          if (_T_608) begin
            instreth <= _T_611;
          end
        end else begin
          if (isEret) begin
            if (_T_608) begin
              instreth <= _T_611;
            end
          end else begin
            if (wen) begin
              if (_T_633) begin
                if (_T_608) begin
                  instreth <= _T_611;
                end
              end else begin
                if (_T_638) begin
                  if (_T_608) begin
                    instreth <= _T_611;
                  end
                end else begin
                  if (_T_641) begin
                    instreth <= _GEN_4;
                  end else begin
                    if (_T_644) begin
                      instreth <= _GEN_4;
                    end else begin
                      if (_T_645) begin
                        instreth <= _GEN_4;
                      end else begin
                        if (_T_646) begin
                          instreth <= _GEN_4;
                        end else begin
                          if (_T_647) begin
                            instreth <= _GEN_4;
                          end else begin
                            if (_T_648) begin
                              instreth <= _GEN_4;
                            end else begin
                              if (_T_653) begin
                                instreth <= _GEN_4;
                              end else begin
                                if (_T_656) begin
                                  instreth <= _GEN_4;
                                end else begin
                                  if (_T_657) begin
                                    instreth <= _GEN_4;
                                  end else begin
                                    if (_T_658) begin
                                      instreth <= _GEN_4;
                                    end else begin
                                      if (_T_659) begin
                                        instreth <= _GEN_4;
                                      end else begin
                                        if (_T_660) begin
                                          instreth <= _GEN_4;
                                        end else begin
                                          if (_T_661) begin
                                            instreth <= _GEN_4;
                                          end else begin
                                            if (_T_662) begin
                                              instreth <= _GEN_4;
                                            end else begin
                                              if (_T_663) begin
                                                instreth <= _GEN_4;
                                              end else begin
                                                if (_T_664) begin
                                                  if (_T_477) begin
                                                    instreth <= io_in;
                                                  end else begin
                                                    if (_T_475) begin
                                                      instreth <= _T_470;
                                                    end else begin
                                                      if (_T_473) begin
                                                        instreth <= _T_472;
                                                      end else begin
                                                        instreth <= 32'h0;
                                                      end
                                                    end
                                                  end
                                                end else begin
                                                  instreth <= _GEN_4;
                                                end
                                              end
                                            end
                                          end
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end else begin
              instreth <= _GEN_4;
            end
          end
        end
      end else begin
        instreth <= _GEN_4;
      end
    end
    if (reset) begin
      PRV <= 2'h3;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          PRV <= 2'h3;
        end else begin
          if (isEret) begin
            PRV <= PRV1;
          end else begin
            if (wen) begin
              if (_T_633) begin
                PRV <= _T_636;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      PRV1 <= 2'h3;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          PRV1 <= PRV;
        end else begin
          if (isEret) begin
            PRV1 <= 2'h0;
          end else begin
            if (wen) begin
              if (_T_633) begin
                PRV1 <= _T_634;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      IE <= 1'h0;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          IE <= 1'h0;
        end else begin
          if (isEret) begin
            IE <= IE1;
          end else begin
            if (wen) begin
              if (_T_633) begin
                IE <= _T_637;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      IE1 <= 1'h0;
    end else begin
      if (_T_601) begin
        if (io_expt) begin
          IE1 <= IE;
        end else begin
          if (isEret) begin
            IE1 <= 1'h1;
          end else begin
            if (wen) begin
              if (_T_633) begin
                IE1 <= _T_635;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      MTIP <= 1'h0;
    end else begin
      if (_T_601) begin
        if (!(io_expt)) begin
          if (!(isEret)) begin
            if (wen) begin
              if (!(_T_633)) begin
                if (_T_638) begin
                  MTIP <= _T_639;
                end
              end
            end
          end
        end
      end
    end
    if (reset) begin
      MTIE <= 1'h0;
    end else begin
      if (_T_601) begin
        if (!(io_expt)) begin
          if (!(isEret)) begin
            if (wen) begin
              if (!(_T_633)) begin
                if (!(_T_638)) begin
                  if (_T_641) begin
                    MTIE <= _T_639;
                  end
                end
              end
            end
          end
        end
      end
    end
    if (reset) begin
      MSIP <= 1'h0;
    end else begin
      if (_T_601) begin
        if (!(io_expt)) begin
          if (!(isEret)) begin
            if (wen) begin
              if (!(_T_633)) begin
                if (_T_638) begin
                  MSIP <= _T_635;
                end
              end
            end
          end
        end
      end
    end
    if (reset) begin
      MSIE <= 1'h0;
    end else begin
      if (_T_601) begin
        if (!(io_expt)) begin
          if (!(isEret)) begin
            if (wen) begin
              if (!(_T_633)) begin
                if (!(_T_638)) begin
                  if (_T_641) begin
                    MSIE <= _T_635;
                  end
                end
              end
            end
          end
        end
      end
    end
    if (_T_601) begin
      if (!(io_expt)) begin
        if (!(isEret)) begin
          if (wen) begin
            if (!(_T_633)) begin
              if (!(_T_638)) begin
                if (!(_T_641)) begin
                  if (!(_T_644)) begin
                    if (!(_T_645)) begin
                      if (_T_646) begin
                        if (_T_477) begin
                          mtimecmp <= io_in;
                        end else begin
                          if (_T_475) begin
                            mtimecmp <= _T_470;
                          end else begin
                            if (_T_473) begin
                              mtimecmp <= _T_472;
                            end else begin
                              mtimecmp <= 32'h0;
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if (_T_601) begin
      if (!(io_expt)) begin
        if (!(isEret)) begin
          if (wen) begin
            if (!(_T_633)) begin
              if (!(_T_638)) begin
                if (!(_T_641)) begin
                  if (!(_T_644)) begin
                    if (!(_T_645)) begin
                      if (!(_T_646)) begin
                        if (_T_647) begin
                          if (_T_477) begin
                            mscratch <= io_in;
                          end else begin
                            if (_T_475) begin
                              mscratch <= _T_470;
                            end else begin
                              if (_T_473) begin
                                mscratch <= _T_472;
                              end else begin
                                mscratch <= 32'h0;
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    mepc <= _GEN_239[31:0];
    if (_T_601) begin
      if (io_expt) begin
        mcause <= {{28'd0}, _T_628};
      end else begin
        if (!(isEret)) begin
          if (wen) begin
            if (!(_T_633)) begin
              if (!(_T_638)) begin
                if (!(_T_641)) begin
                  if (!(_T_644)) begin
                    if (!(_T_645)) begin
                      if (!(_T_646)) begin
                        if (!(_T_647)) begin
                          if (!(_T_648)) begin
                            if (_T_653) begin
                              mcause <= _T_655;
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if (_T_601) begin
      if (io_expt) begin
        if (_T_631) begin
          mbadaddr <= io_addr;
        end
      end else begin
        if (!(isEret)) begin
          if (wen) begin
            if (!(_T_633)) begin
              if (!(_T_638)) begin
                if (!(_T_641)) begin
                  if (!(_T_644)) begin
                    if (!(_T_645)) begin
                      if (!(_T_646)) begin
                        if (!(_T_647)) begin
                          if (!(_T_648)) begin
                            if (!(_T_653)) begin
                              if (_T_656) begin
                                if (_T_477) begin
                                  mbadaddr <= io_in;
                                end else begin
                                  if (_T_475) begin
                                    mbadaddr <= _T_470;
                                  end else begin
                                    if (_T_473) begin
                                      mbadaddr <= _T_472;
                                    end else begin
                                      mbadaddr <= 32'h0;
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if (reset) begin
      mtohost <= 32'h0;
    end else begin
      if (_T_601) begin
        if (!(io_expt)) begin
          if (!(isEret)) begin
            if (wen) begin
              if (!(_T_633)) begin
                if (!(_T_638)) begin
                  if (!(_T_641)) begin
                    if (!(_T_644)) begin
                      if (!(_T_645)) begin
                        if (!(_T_646)) begin
                          if (!(_T_647)) begin
                            if (!(_T_648)) begin
                              if (!(_T_653)) begin
                                if (!(_T_656)) begin
                                  if (_T_657) begin
                                    if (_T_477) begin
                                      mtohost <= io_in;
                                    end else begin
                                      if (_T_475) begin
                                        mtohost <= _T_470;
                                      end else begin
                                        if (_T_473) begin
                                          mtohost <= _T_472;
                                        end else begin
                                          mtohost <= 32'h0;
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if (_T_601) begin
      if (!(io_expt)) begin
        if (!(isEret)) begin
          if (wen) begin
            if (!(_T_633)) begin
              if (!(_T_638)) begin
                if (!(_T_641)) begin
                  if (!(_T_644)) begin
                    if (!(_T_645)) begin
                      if (!(_T_646)) begin
                        if (!(_T_647)) begin
                          if (!(_T_648)) begin
                            if (!(_T_653)) begin
                              if (!(_T_656)) begin
                                if (!(_T_657)) begin
                                  if (_T_658) begin
                                    if (_T_477) begin
                                      mfromhost <= io_in;
                                    end else begin
                                      if (_T_475) begin
                                        mfromhost <= _T_470;
                                      end else begin
                                        if (_T_473) begin
                                          mfromhost <= _T_472;
                                        end else begin
                                          mfromhost <= 32'h0;
                                        end
                                      end
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
endmodule
module RegFile(
  input         clock,
  input  [4:0]  io_raddr1,
  input  [4:0]  io_raddr2,
  output [31:0] io_rdata1,
  output [31:0] io_rdata2,
  input         io_wen,
  input  [4:0]  io_waddr,
  input  [31:0] io_wdata
);
  reg [31:0] regs [0:31]; // @[RegFile.scala 20:17]
  reg [31:0] _RAND_0;
  wire [31:0] regs__T_23_data; // @[RegFile.scala 20:17]
  wire [4:0] regs__T_23_addr; // @[RegFile.scala 20:17]
  wire [31:0] regs__T_28_data; // @[RegFile.scala 20:17]
  wire [4:0] regs__T_28_addr; // @[RegFile.scala 20:17]
  wire [31:0] regs__T_34_data; // @[RegFile.scala 20:17]
  wire [4:0] regs__T_34_addr; // @[RegFile.scala 20:17]
  wire  regs__T_34_mask; // @[RegFile.scala 20:17]
  wire  regs__T_34_en; // @[RegFile.scala 20:17]
  wire  _T_22; // @[RegFile.scala 21:30]
  wire [31:0] _T_25; // @[RegFile.scala 21:19]
  wire  _T_27; // @[RegFile.scala 22:30]
  wire [31:0] _T_30; // @[RegFile.scala 22:19]
  wire  _T_32; // @[RegFile.scala 23:26]
  wire  _T_33; // @[RegFile.scala 23:15]
  assign regs__T_23_addr = io_raddr1;
  assign regs__T_23_data = regs[regs__T_23_addr]; // @[RegFile.scala 20:17]
  assign regs__T_28_addr = io_raddr2;
  assign regs__T_28_data = regs[regs__T_28_addr]; // @[RegFile.scala 20:17]
  assign regs__T_34_data = io_wdata;
  assign regs__T_34_addr = io_waddr;
  assign regs__T_34_mask = _T_33;
  assign regs__T_34_en = _T_33;
  assign _T_22 = io_raddr1 != 5'h0; // @[RegFile.scala 21:30]
  assign _T_25 = _T_22 ? regs__T_23_data : 32'h0; // @[RegFile.scala 21:19]
  assign _T_27 = io_raddr2 != 5'h0; // @[RegFile.scala 22:30]
  assign _T_30 = _T_27 ? regs__T_28_data : 32'h0; // @[RegFile.scala 22:19]
  assign _T_32 = io_waddr != 5'h0; // @[RegFile.scala 23:26]
  assign _T_33 = io_wen & _T_32; // @[RegFile.scala 23:15]
  assign io_rdata1 = _T_25;
  assign io_rdata2 = _T_30;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  _RAND_0 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    regs[initvar] = _RAND_0[31:0];
  `endif // RANDOMIZE_MEM_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if(regs__T_34_en & regs__T_34_mask) begin
      regs[regs__T_34_addr] <= regs__T_34_data; // @[RegFile.scala 20:17]
    end
  end
endmodule
module ALUArea(
  input  [31:0] io_A,
  input  [31:0] io_B,
  input  [3:0]  io_alu_op,
  output [31:0] io_out,
  output [31:0] io_sum
);
  wire  _T_15; // @[ALU.scala 59:33]
  wire [32:0] _T_17; // @[ALU.scala 59:38]
  wire [32:0] _T_18; // @[ALU.scala 59:38]
  wire [31:0] _T_19; // @[ALU.scala 59:38]
  wire [31:0] _T_20; // @[ALU.scala 59:23]
  wire [32:0] _T_21; // @[ALU.scala 59:18]
  wire [31:0] sum; // @[ALU.scala 59:18]
  wire  _T_22; // @[ALU.scala 60:21]
  wire  _T_23; // @[ALU.scala 60:38]
  wire  _T_24; // @[ALU.scala 60:30]
  wire  _T_25; // @[ALU.scala 60:51]
  wire  _T_26; // @[ALU.scala 61:26]
  wire  _T_29; // @[ALU.scala 61:16]
  wire  cmp; // @[ALU.scala 60:16]
  wire [4:0] shamt; // @[ALU.scala 62:20]
  wire  _T_30; // @[ALU.scala 63:29]
  wire [15:0] _T_35; // @[Bitwise.scala 103:21]
  wire [31:0] _T_36; // @[Bitwise.scala 103:31]
  wire [15:0] _T_37; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_0; // @[Bitwise.scala 103:65]
  wire [31:0] _T_38; // @[Bitwise.scala 103:65]
  wire [31:0] _T_40; // @[Bitwise.scala 103:75]
  wire [31:0] _T_41; // @[Bitwise.scala 103:39]
  wire [23:0] _T_45; // @[Bitwise.scala 103:21]
  wire [31:0] _GEN_1; // @[Bitwise.scala 103:31]
  wire [31:0] _T_46; // @[Bitwise.scala 103:31]
  wire [23:0] _T_47; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_2; // @[Bitwise.scala 103:65]
  wire [31:0] _T_48; // @[Bitwise.scala 103:65]
  wire [31:0] _T_50; // @[Bitwise.scala 103:75]
  wire [31:0] _T_51; // @[Bitwise.scala 103:39]
  wire [27:0] _T_55; // @[Bitwise.scala 103:21]
  wire [31:0] _GEN_3; // @[Bitwise.scala 103:31]
  wire [31:0] _T_56; // @[Bitwise.scala 103:31]
  wire [27:0] _T_57; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_4; // @[Bitwise.scala 103:65]
  wire [31:0] _T_58; // @[Bitwise.scala 103:65]
  wire [31:0] _T_60; // @[Bitwise.scala 103:75]
  wire [31:0] _T_61; // @[Bitwise.scala 103:39]
  wire [29:0] _T_65; // @[Bitwise.scala 103:21]
  wire [31:0] _GEN_5; // @[Bitwise.scala 103:31]
  wire [31:0] _T_66; // @[Bitwise.scala 103:31]
  wire [29:0] _T_67; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_6; // @[Bitwise.scala 103:65]
  wire [31:0] _T_68; // @[Bitwise.scala 103:65]
  wire [31:0] _T_70; // @[Bitwise.scala 103:75]
  wire [31:0] _T_71; // @[Bitwise.scala 103:39]
  wire [30:0] _T_75; // @[Bitwise.scala 103:21]
  wire [31:0] _GEN_7; // @[Bitwise.scala 103:31]
  wire [31:0] _T_76; // @[Bitwise.scala 103:31]
  wire [30:0] _T_77; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_8; // @[Bitwise.scala 103:65]
  wire [31:0] _T_78; // @[Bitwise.scala 103:65]
  wire [31:0] _T_80; // @[Bitwise.scala 103:75]
  wire [31:0] _T_81; // @[Bitwise.scala 103:39]
  wire [31:0] shin; // @[ALU.scala 63:19]
  wire  _T_83; // @[ALU.scala 64:41]
  wire  _T_84; // @[ALU.scala 64:34]
  wire [32:0] _T_85; // @[Cat.scala 30:58]
  wire [32:0] _T_86; // @[ALU.scala 64:57]
  wire [32:0] _T_87; // @[ALU.scala 64:64]
  wire [31:0] shiftr; // @[ALU.scala 64:73]
  wire [15:0] _T_92; // @[Bitwise.scala 103:21]
  wire [31:0] _T_93; // @[Bitwise.scala 103:31]
  wire [15:0] _T_94; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_9; // @[Bitwise.scala 103:65]
  wire [31:0] _T_95; // @[Bitwise.scala 103:65]
  wire [31:0] _T_97; // @[Bitwise.scala 103:75]
  wire [31:0] _T_98; // @[Bitwise.scala 103:39]
  wire [23:0] _T_102; // @[Bitwise.scala 103:21]
  wire [31:0] _GEN_10; // @[Bitwise.scala 103:31]
  wire [31:0] _T_103; // @[Bitwise.scala 103:31]
  wire [23:0] _T_104; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_11; // @[Bitwise.scala 103:65]
  wire [31:0] _T_105; // @[Bitwise.scala 103:65]
  wire [31:0] _T_107; // @[Bitwise.scala 103:75]
  wire [31:0] _T_108; // @[Bitwise.scala 103:39]
  wire [27:0] _T_112; // @[Bitwise.scala 103:21]
  wire [31:0] _GEN_12; // @[Bitwise.scala 103:31]
  wire [31:0] _T_113; // @[Bitwise.scala 103:31]
  wire [27:0] _T_114; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_13; // @[Bitwise.scala 103:65]
  wire [31:0] _T_115; // @[Bitwise.scala 103:65]
  wire [31:0] _T_117; // @[Bitwise.scala 103:75]
  wire [31:0] _T_118; // @[Bitwise.scala 103:39]
  wire [29:0] _T_122; // @[Bitwise.scala 103:21]
  wire [31:0] _GEN_14; // @[Bitwise.scala 103:31]
  wire [31:0] _T_123; // @[Bitwise.scala 103:31]
  wire [29:0] _T_124; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_15; // @[Bitwise.scala 103:65]
  wire [31:0] _T_125; // @[Bitwise.scala 103:65]
  wire [31:0] _T_127; // @[Bitwise.scala 103:75]
  wire [31:0] _T_128; // @[Bitwise.scala 103:39]
  wire [30:0] _T_132; // @[Bitwise.scala 103:21]
  wire [31:0] _GEN_16; // @[Bitwise.scala 103:31]
  wire [31:0] _T_133; // @[Bitwise.scala 103:31]
  wire [30:0] _T_134; // @[Bitwise.scala 103:46]
  wire [31:0] _GEN_17; // @[Bitwise.scala 103:65]
  wire [31:0] _T_135; // @[Bitwise.scala 103:65]
  wire [31:0] _T_137; // @[Bitwise.scala 103:75]
  wire [31:0] shiftl; // @[Bitwise.scala 103:39]
  wire  _T_138; // @[ALU.scala 68:19]
  wire  _T_139; // @[ALU.scala 68:44]
  wire  _T_140; // @[ALU.scala 68:31]
  wire  _T_141; // @[ALU.scala 69:19]
  wire  _T_142; // @[ALU.scala 69:44]
  wire  _T_143; // @[ALU.scala 69:31]
  wire  _T_144; // @[ALU.scala 70:19]
  wire  _T_145; // @[ALU.scala 70:44]
  wire  _T_146; // @[ALU.scala 70:31]
  wire  _T_147; // @[ALU.scala 71:19]
  wire  _T_148; // @[ALU.scala 72:19]
  wire [31:0] _T_149; // @[ALU.scala 72:38]
  wire  _T_150; // @[ALU.scala 73:19]
  wire [31:0] _T_151; // @[ALU.scala 73:38]
  wire  _T_152; // @[ALU.scala 74:19]
  wire [31:0] _T_153; // @[ALU.scala 74:38]
  wire  _T_154; // @[ALU.scala 75:19]
  wire [31:0] _T_155; // @[ALU.scala 75:8]
  wire [31:0] _T_156; // @[ALU.scala 74:8]
  wire [31:0] _T_157; // @[ALU.scala 73:8]
  wire [31:0] _T_158; // @[ALU.scala 72:8]
  wire [31:0] _T_159; // @[ALU.scala 71:8]
  wire [31:0] _T_160; // @[ALU.scala 70:8]
  wire [31:0] _T_161; // @[ALU.scala 69:8]
  wire [31:0] out; // @[ALU.scala 68:8]
  assign _T_15 = io_alu_op[0]; // @[ALU.scala 59:33]
  assign _T_17 = 32'h0 - io_B; // @[ALU.scala 59:38]
  assign _T_18 = $unsigned(_T_17); // @[ALU.scala 59:38]
  assign _T_19 = _T_18[31:0]; // @[ALU.scala 59:38]
  assign _T_20 = _T_15 ? _T_19 : io_B; // @[ALU.scala 59:23]
  assign _T_21 = io_A + _T_20; // @[ALU.scala 59:18]
  assign sum = _T_21[31:0]; // @[ALU.scala 59:18]
  assign _T_22 = io_A[31]; // @[ALU.scala 60:21]
  assign _T_23 = io_B[31]; // @[ALU.scala 60:38]
  assign _T_24 = _T_22 == _T_23; // @[ALU.scala 60:30]
  assign _T_25 = sum[31]; // @[ALU.scala 60:51]
  assign _T_26 = io_alu_op[1]; // @[ALU.scala 61:26]
  assign _T_29 = _T_26 ? _T_23 : _T_22; // @[ALU.scala 61:16]
  assign cmp = _T_24 ? _T_25 : _T_29; // @[ALU.scala 60:16]
  assign shamt = io_B[4:0]; // @[ALU.scala 62:20]
  assign _T_30 = io_alu_op[3]; // @[ALU.scala 63:29]
  assign _T_35 = io_A[31:16]; // @[Bitwise.scala 103:21]
  assign _T_36 = {{16'd0}, _T_35}; // @[Bitwise.scala 103:31]
  assign _T_37 = io_A[15:0]; // @[Bitwise.scala 103:46]
  assign _GEN_0 = {{16'd0}, _T_37}; // @[Bitwise.scala 103:65]
  assign _T_38 = _GEN_0 << 16; // @[Bitwise.scala 103:65]
  assign _T_40 = _T_38 & 32'hffff0000; // @[Bitwise.scala 103:75]
  assign _T_41 = _T_36 | _T_40; // @[Bitwise.scala 103:39]
  assign _T_45 = _T_41[31:8]; // @[Bitwise.scala 103:21]
  assign _GEN_1 = {{8'd0}, _T_45}; // @[Bitwise.scala 103:31]
  assign _T_46 = _GEN_1 & 32'hff00ff; // @[Bitwise.scala 103:31]
  assign _T_47 = _T_41[23:0]; // @[Bitwise.scala 103:46]
  assign _GEN_2 = {{8'd0}, _T_47}; // @[Bitwise.scala 103:65]
  assign _T_48 = _GEN_2 << 8; // @[Bitwise.scala 103:65]
  assign _T_50 = _T_48 & 32'hff00ff00; // @[Bitwise.scala 103:75]
  assign _T_51 = _T_46 | _T_50; // @[Bitwise.scala 103:39]
  assign _T_55 = _T_51[31:4]; // @[Bitwise.scala 103:21]
  assign _GEN_3 = {{4'd0}, _T_55}; // @[Bitwise.scala 103:31]
  assign _T_56 = _GEN_3 & 32'hf0f0f0f; // @[Bitwise.scala 103:31]
  assign _T_57 = _T_51[27:0]; // @[Bitwise.scala 103:46]
  assign _GEN_4 = {{4'd0}, _T_57}; // @[Bitwise.scala 103:65]
  assign _T_58 = _GEN_4 << 4; // @[Bitwise.scala 103:65]
  assign _T_60 = _T_58 & 32'hf0f0f0f0; // @[Bitwise.scala 103:75]
  assign _T_61 = _T_56 | _T_60; // @[Bitwise.scala 103:39]
  assign _T_65 = _T_61[31:2]; // @[Bitwise.scala 103:21]
  assign _GEN_5 = {{2'd0}, _T_65}; // @[Bitwise.scala 103:31]
  assign _T_66 = _GEN_5 & 32'h33333333; // @[Bitwise.scala 103:31]
  assign _T_67 = _T_61[29:0]; // @[Bitwise.scala 103:46]
  assign _GEN_6 = {{2'd0}, _T_67}; // @[Bitwise.scala 103:65]
  assign _T_68 = _GEN_6 << 2; // @[Bitwise.scala 103:65]
  assign _T_70 = _T_68 & 32'hcccccccc; // @[Bitwise.scala 103:75]
  assign _T_71 = _T_66 | _T_70; // @[Bitwise.scala 103:39]
  assign _T_75 = _T_71[31:1]; // @[Bitwise.scala 103:21]
  assign _GEN_7 = {{1'd0}, _T_75}; // @[Bitwise.scala 103:31]
  assign _T_76 = _GEN_7 & 32'h55555555; // @[Bitwise.scala 103:31]
  assign _T_77 = _T_71[30:0]; // @[Bitwise.scala 103:46]
  assign _GEN_8 = {{1'd0}, _T_77}; // @[Bitwise.scala 103:65]
  assign _T_78 = _GEN_8 << 1; // @[Bitwise.scala 103:65]
  assign _T_80 = _T_78 & 32'haaaaaaaa; // @[Bitwise.scala 103:75]
  assign _T_81 = _T_76 | _T_80; // @[Bitwise.scala 103:39]
  assign shin = _T_30 ? io_A : _T_81; // @[ALU.scala 63:19]
  assign _T_83 = shin[31]; // @[ALU.scala 64:41]
  assign _T_84 = _T_15 & _T_83; // @[ALU.scala 64:34]
  assign _T_85 = {_T_84,shin}; // @[Cat.scala 30:58]
  assign _T_86 = $signed(_T_85); // @[ALU.scala 64:57]
  assign _T_87 = $signed(_T_86) >>> shamt; // @[ALU.scala 64:64]
  assign shiftr = _T_87[31:0]; // @[ALU.scala 64:73]
  assign _T_92 = shiftr[31:16]; // @[Bitwise.scala 103:21]
  assign _T_93 = {{16'd0}, _T_92}; // @[Bitwise.scala 103:31]
  assign _T_94 = shiftr[15:0]; // @[Bitwise.scala 103:46]
  assign _GEN_9 = {{16'd0}, _T_94}; // @[Bitwise.scala 103:65]
  assign _T_95 = _GEN_9 << 16; // @[Bitwise.scala 103:65]
  assign _T_97 = _T_95 & 32'hffff0000; // @[Bitwise.scala 103:75]
  assign _T_98 = _T_93 | _T_97; // @[Bitwise.scala 103:39]
  assign _T_102 = _T_98[31:8]; // @[Bitwise.scala 103:21]
  assign _GEN_10 = {{8'd0}, _T_102}; // @[Bitwise.scala 103:31]
  assign _T_103 = _GEN_10 & 32'hff00ff; // @[Bitwise.scala 103:31]
  assign _T_104 = _T_98[23:0]; // @[Bitwise.scala 103:46]
  assign _GEN_11 = {{8'd0}, _T_104}; // @[Bitwise.scala 103:65]
  assign _T_105 = _GEN_11 << 8; // @[Bitwise.scala 103:65]
  assign _T_107 = _T_105 & 32'hff00ff00; // @[Bitwise.scala 103:75]
  assign _T_108 = _T_103 | _T_107; // @[Bitwise.scala 103:39]
  assign _T_112 = _T_108[31:4]; // @[Bitwise.scala 103:21]
  assign _GEN_12 = {{4'd0}, _T_112}; // @[Bitwise.scala 103:31]
  assign _T_113 = _GEN_12 & 32'hf0f0f0f; // @[Bitwise.scala 103:31]
  assign _T_114 = _T_108[27:0]; // @[Bitwise.scala 103:46]
  assign _GEN_13 = {{4'd0}, _T_114}; // @[Bitwise.scala 103:65]
  assign _T_115 = _GEN_13 << 4; // @[Bitwise.scala 103:65]
  assign _T_117 = _T_115 & 32'hf0f0f0f0; // @[Bitwise.scala 103:75]
  assign _T_118 = _T_113 | _T_117; // @[Bitwise.scala 103:39]
  assign _T_122 = _T_118[31:2]; // @[Bitwise.scala 103:21]
  assign _GEN_14 = {{2'd0}, _T_122}; // @[Bitwise.scala 103:31]
  assign _T_123 = _GEN_14 & 32'h33333333; // @[Bitwise.scala 103:31]
  assign _T_124 = _T_118[29:0]; // @[Bitwise.scala 103:46]
  assign _GEN_15 = {{2'd0}, _T_124}; // @[Bitwise.scala 103:65]
  assign _T_125 = _GEN_15 << 2; // @[Bitwise.scala 103:65]
  assign _T_127 = _T_125 & 32'hcccccccc; // @[Bitwise.scala 103:75]
  assign _T_128 = _T_123 | _T_127; // @[Bitwise.scala 103:39]
  assign _T_132 = _T_128[31:1]; // @[Bitwise.scala 103:21]
  assign _GEN_16 = {{1'd0}, _T_132}; // @[Bitwise.scala 103:31]
  assign _T_133 = _GEN_16 & 32'h55555555; // @[Bitwise.scala 103:31]
  assign _T_134 = _T_128[30:0]; // @[Bitwise.scala 103:46]
  assign _GEN_17 = {{1'd0}, _T_134}; // @[Bitwise.scala 103:65]
  assign _T_135 = _GEN_17 << 1; // @[Bitwise.scala 103:65]
  assign _T_137 = _T_135 & 32'haaaaaaaa; // @[Bitwise.scala 103:75]
  assign shiftl = _T_133 | _T_137; // @[Bitwise.scala 103:39]
  assign _T_138 = io_alu_op == 4'h0; // @[ALU.scala 68:19]
  assign _T_139 = io_alu_op == 4'h1; // @[ALU.scala 68:44]
  assign _T_140 = _T_138 | _T_139; // @[ALU.scala 68:31]
  assign _T_141 = io_alu_op == 4'h5; // @[ALU.scala 69:19]
  assign _T_142 = io_alu_op == 4'h7; // @[ALU.scala 69:44]
  assign _T_143 = _T_141 | _T_142; // @[ALU.scala 69:31]
  assign _T_144 = io_alu_op == 4'h9; // @[ALU.scala 70:19]
  assign _T_145 = io_alu_op == 4'h8; // @[ALU.scala 70:44]
  assign _T_146 = _T_144 | _T_145; // @[ALU.scala 70:31]
  assign _T_147 = io_alu_op == 4'h6; // @[ALU.scala 71:19]
  assign _T_148 = io_alu_op == 4'h2; // @[ALU.scala 72:19]
  assign _T_149 = io_A & io_B; // @[ALU.scala 72:38]
  assign _T_150 = io_alu_op == 4'h3; // @[ALU.scala 73:19]
  assign _T_151 = io_A | io_B; // @[ALU.scala 73:38]
  assign _T_152 = io_alu_op == 4'h4; // @[ALU.scala 74:19]
  assign _T_153 = io_A ^ io_B; // @[ALU.scala 74:38]
  assign _T_154 = io_alu_op == 4'ha; // @[ALU.scala 75:19]
  assign _T_155 = _T_154 ? io_A : io_B; // @[ALU.scala 75:8]
  assign _T_156 = _T_152 ? _T_153 : _T_155; // @[ALU.scala 74:8]
  assign _T_157 = _T_150 ? _T_151 : _T_156; // @[ALU.scala 73:8]
  assign _T_158 = _T_148 ? _T_149 : _T_157; // @[ALU.scala 72:8]
  assign _T_159 = _T_147 ? shiftl : _T_158; // @[ALU.scala 71:8]
  assign _T_160 = _T_146 ? shiftr : _T_159; // @[ALU.scala 70:8]
  assign _T_161 = _T_143 ? {{31'd0}, cmp} : _T_160; // @[ALU.scala 69:8]
  assign out = _T_140 ? sum : _T_161; // @[ALU.scala 68:8]
  assign io_out = out;
  assign io_sum = sum;
endmodule
module ImmGenWire(
  input  [31:0] io_inst,
  input  [2:0]  io_sel,
  output [31:0] io_out
);
  wire [11:0] _T_11; // @[ImmGen.scala 21:21]
  wire [11:0] Iimm; // @[ImmGen.scala 21:30]
  wire [6:0] _T_12; // @[ImmGen.scala 22:25]
  wire [4:0] _T_13; // @[ImmGen.scala 22:42]
  wire [11:0] _T_14; // @[Cat.scala 30:58]
  wire [11:0] Simm; // @[ImmGen.scala 22:50]
  wire  _T_15; // @[ImmGen.scala 23:25]
  wire  _T_16; // @[ImmGen.scala 23:38]
  wire [5:0] _T_17; // @[ImmGen.scala 23:50]
  wire [3:0] _T_18; // @[ImmGen.scala 23:67]
  wire [4:0] _T_20; // @[Cat.scala 30:58]
  wire [1:0] _T_21; // @[Cat.scala 30:58]
  wire [7:0] _T_22; // @[Cat.scala 30:58]
  wire [12:0] _T_23; // @[Cat.scala 30:58]
  wire [12:0] Bimm; // @[ImmGen.scala 23:86]
  wire [19:0] _T_24; // @[ImmGen.scala 24:25]
  wire [31:0] _T_26; // @[Cat.scala 30:58]
  wire [31:0] Uimm; // @[ImmGen.scala 24:46]
  wire [7:0] _T_28; // @[ImmGen.scala 25:38]
  wire  _T_29; // @[ImmGen.scala 25:55]
  wire [3:0] _T_31; // @[ImmGen.scala 25:85]
  wire [9:0] _T_33; // @[Cat.scala 30:58]
  wire [10:0] _T_34; // @[Cat.scala 30:58]
  wire [8:0] _T_35; // @[Cat.scala 30:58]
  wire [9:0] _T_36; // @[Cat.scala 30:58]
  wire [20:0] _T_37; // @[Cat.scala 30:58]
  wire [20:0] Jimm; // @[ImmGen.scala 25:105]
  wire [4:0] _T_38; // @[ImmGen.scala 26:21]
  wire [5:0] Zimm; // @[ImmGen.scala 26:30]
  wire [11:0] _T_40; // @[ImmGen.scala 28:36]
  wire [11:0] _T_41; // @[ImmGen.scala 28:36]
  wire  _T_42; // @[Mux.scala 46:19]
  wire [11:0] _T_43; // @[Mux.scala 46:16]
  wire  _T_44; // @[Mux.scala 46:19]
  wire [20:0] _T_45; // @[Mux.scala 46:16]
  wire  _T_46; // @[Mux.scala 46:19]
  wire [31:0] _T_47; // @[Mux.scala 46:16]
  wire  _T_48; // @[Mux.scala 46:19]
  wire [31:0] _T_49; // @[Mux.scala 46:16]
  wire  _T_50; // @[Mux.scala 46:19]
  wire [31:0] _T_51; // @[Mux.scala 46:16]
  wire  _T_52; // @[Mux.scala 46:19]
  wire [31:0] _T_53; // @[Mux.scala 46:16]
  wire [31:0] _T_54; // @[ImmGen.scala 29:100]
  assign _T_11 = io_inst[31:20]; // @[ImmGen.scala 21:21]
  assign Iimm = $signed(_T_11); // @[ImmGen.scala 21:30]
  assign _T_12 = io_inst[31:25]; // @[ImmGen.scala 22:25]
  assign _T_13 = io_inst[11:7]; // @[ImmGen.scala 22:42]
  assign _T_14 = {_T_12,_T_13}; // @[Cat.scala 30:58]
  assign Simm = $signed(_T_14); // @[ImmGen.scala 22:50]
  assign _T_15 = io_inst[31]; // @[ImmGen.scala 23:25]
  assign _T_16 = io_inst[7]; // @[ImmGen.scala 23:38]
  assign _T_17 = io_inst[30:25]; // @[ImmGen.scala 23:50]
  assign _T_18 = io_inst[11:8]; // @[ImmGen.scala 23:67]
  assign _T_20 = {_T_18,1'h0}; // @[Cat.scala 30:58]
  assign _T_21 = {_T_15,_T_16}; // @[Cat.scala 30:58]
  assign _T_22 = {_T_21,_T_17}; // @[Cat.scala 30:58]
  assign _T_23 = {_T_22,_T_20}; // @[Cat.scala 30:58]
  assign Bimm = $signed(_T_23); // @[ImmGen.scala 23:86]
  assign _T_24 = io_inst[31:12]; // @[ImmGen.scala 24:25]
  assign _T_26 = {_T_24,12'h0}; // @[Cat.scala 30:58]
  assign Uimm = $signed(_T_26); // @[ImmGen.scala 24:46]
  assign _T_28 = io_inst[19:12]; // @[ImmGen.scala 25:38]
  assign _T_29 = io_inst[20]; // @[ImmGen.scala 25:55]
  assign _T_31 = io_inst[24:21]; // @[ImmGen.scala 25:85]
  assign _T_33 = {_T_17,_T_31}; // @[Cat.scala 30:58]
  assign _T_34 = {_T_33,1'h0}; // @[Cat.scala 30:58]
  assign _T_35 = {_T_15,_T_28}; // @[Cat.scala 30:58]
  assign _T_36 = {_T_35,_T_29}; // @[Cat.scala 30:58]
  assign _T_37 = {_T_36,_T_34}; // @[Cat.scala 30:58]
  assign Jimm = $signed(_T_37); // @[ImmGen.scala 25:105]
  assign _T_38 = io_inst[19:15]; // @[ImmGen.scala 26:21]
  assign Zimm = {1'b0,$signed(_T_38)}; // @[ImmGen.scala 26:30]
  assign _T_40 = $signed(Iimm) & $signed(-12'sh2); // @[ImmGen.scala 28:36]
  assign _T_41 = $signed(_T_40); // @[ImmGen.scala 28:36]
  assign _T_42 = 3'h6 == io_sel; // @[Mux.scala 46:19]
  assign _T_43 = _T_42 ? $signed({{6{Zimm[5]}},Zimm}) : $signed(_T_41); // @[Mux.scala 46:16]
  assign _T_44 = 3'h4 == io_sel; // @[Mux.scala 46:19]
  assign _T_45 = _T_44 ? $signed(Jimm) : $signed({{9{_T_43[11]}},_T_43}); // @[Mux.scala 46:16]
  assign _T_46 = 3'h3 == io_sel; // @[Mux.scala 46:19]
  assign _T_47 = _T_46 ? $signed(Uimm) : $signed({{11{_T_45[20]}},_T_45}); // @[Mux.scala 46:16]
  assign _T_48 = 3'h5 == io_sel; // @[Mux.scala 46:19]
  assign _T_49 = _T_48 ? $signed({{19{Bimm[12]}},Bimm}) : $signed(_T_47); // @[Mux.scala 46:16]
  assign _T_50 = 3'h2 == io_sel; // @[Mux.scala 46:19]
  assign _T_51 = _T_50 ? $signed({{20{Simm[11]}},Simm}) : $signed(_T_49); // @[Mux.scala 46:16]
  assign _T_52 = 3'h1 == io_sel; // @[Mux.scala 46:19]
  assign _T_53 = _T_52 ? $signed({{20{Iimm[11]}},Iimm}) : $signed(_T_51); // @[Mux.scala 46:16]
  assign _T_54 = $unsigned(_T_53); // @[ImmGen.scala 29:100]
  assign io_out = _T_54;
endmodule
module BrCondArea(
  input  [31:0] io_rs1,
  input  [31:0] io_rs2,
  input  [2:0]  io_br_type,
  output        io_taken
);
  wire [32:0] _T_13; // @[BrCond.scala 37:21]
  wire [32:0] _T_14; // @[BrCond.scala 37:21]
  wire [31:0] diff; // @[BrCond.scala 37:21]
  wire  neq; // @[BrCond.scala 38:19]
  wire  eq; // @[BrCond.scala 39:14]
  wire  _T_17; // @[BrCond.scala 40:26]
  wire  _T_18; // @[BrCond.scala 40:45]
  wire  isSameSign; // @[BrCond.scala 40:35]
  wire  _T_19; // @[BrCond.scala 41:34]
  wire  lt; // @[BrCond.scala 41:17]
  wire  ltu; // @[BrCond.scala 42:17]
  wire  ge; // @[BrCond.scala 43:14]
  wire  geu; // @[BrCond.scala 44:14]
  wire  _T_25; // @[BrCond.scala 46:18]
  wire  _T_26; // @[BrCond.scala 46:29]
  wire  _T_27; // @[BrCond.scala 47:18]
  wire  _T_28; // @[BrCond.scala 47:29]
  wire  _T_29; // @[BrCond.scala 46:36]
  wire  _T_30; // @[BrCond.scala 48:18]
  wire  _T_31; // @[BrCond.scala 48:29]
  wire  _T_32; // @[BrCond.scala 47:37]
  wire  _T_33; // @[BrCond.scala 49:18]
  wire  _T_34; // @[BrCond.scala 49:29]
  wire  _T_35; // @[BrCond.scala 48:36]
  wire  _T_36; // @[BrCond.scala 50:18]
  wire  _T_37; // @[BrCond.scala 50:30]
  wire  _T_38; // @[BrCond.scala 49:36]
  wire  _T_39; // @[BrCond.scala 51:18]
  wire  _T_40; // @[BrCond.scala 51:30]
  wire  _T_41; // @[BrCond.scala 50:38]
  assign _T_13 = io_rs1 - io_rs2; // @[BrCond.scala 37:21]
  assign _T_14 = $unsigned(_T_13); // @[BrCond.scala 37:21]
  assign diff = _T_14[31:0]; // @[BrCond.scala 37:21]
  assign neq = diff != 32'h0; // @[BrCond.scala 38:19]
  assign eq = neq == 1'h0; // @[BrCond.scala 39:14]
  assign _T_17 = io_rs1[31]; // @[BrCond.scala 40:26]
  assign _T_18 = io_rs2[31]; // @[BrCond.scala 40:45]
  assign isSameSign = _T_17 == _T_18; // @[BrCond.scala 40:35]
  assign _T_19 = diff[31]; // @[BrCond.scala 41:34]
  assign lt = isSameSign ? _T_19 : _T_17; // @[BrCond.scala 41:17]
  assign ltu = isSameSign ? _T_19 : _T_18; // @[BrCond.scala 42:17]
  assign ge = lt == 1'h0; // @[BrCond.scala 43:14]
  assign geu = ltu == 1'h0; // @[BrCond.scala 44:14]
  assign _T_25 = io_br_type == 3'h3; // @[BrCond.scala 46:18]
  assign _T_26 = _T_25 & eq; // @[BrCond.scala 46:29]
  assign _T_27 = io_br_type == 3'h6; // @[BrCond.scala 47:18]
  assign _T_28 = _T_27 & neq; // @[BrCond.scala 47:29]
  assign _T_29 = _T_26 | _T_28; // @[BrCond.scala 46:36]
  assign _T_30 = io_br_type == 3'h2; // @[BrCond.scala 48:18]
  assign _T_31 = _T_30 & lt; // @[BrCond.scala 48:29]
  assign _T_32 = _T_29 | _T_31; // @[BrCond.scala 47:37]
  assign _T_33 = io_br_type == 3'h5; // @[BrCond.scala 49:18]
  assign _T_34 = _T_33 & ge; // @[BrCond.scala 49:29]
  assign _T_35 = _T_32 | _T_34; // @[BrCond.scala 48:36]
  assign _T_36 = io_br_type == 3'h1; // @[BrCond.scala 50:18]
  assign _T_37 = _T_36 & ltu; // @[BrCond.scala 50:30]
  assign _T_38 = _T_35 | _T_37; // @[BrCond.scala 49:36]
  assign _T_39 = io_br_type == 3'h4; // @[BrCond.scala 51:18]
  assign _T_40 = _T_39 & geu; // @[BrCond.scala 51:30]
  assign _T_41 = _T_38 | _T_40; // @[BrCond.scala 50:38]
  assign io_taken = _T_41;
endmodule
module Datapath(
  input         clock,
  input         reset,
  output        io_icache_req_valid,
  output [31:0] io_icache_req_bits_addr,
  input         io_icache_resp_valid,
  input  [31:0] io_icache_resp_bits_data,
  output        io_dcache_abort,
  output        io_dcache_req_valid,
  output [31:0] io_dcache_req_bits_addr,
  output [31:0] io_dcache_req_bits_data,
  output [3:0]  io_dcache_req_bits_mask,
  input         io_dcache_resp_valid,
  input  [31:0] io_dcache_resp_bits_data,
  output [31:0] io_ctrl_inst,
  input  [1:0]  io_ctrl_pc_sel,
  input         io_ctrl_inst_kill,
  input         io_ctrl_A_sel,
  input         io_ctrl_B_sel,
  input  [2:0]  io_ctrl_imm_sel,
  input  [3:0]  io_ctrl_alu_op,
  input  [2:0]  io_ctrl_br_type,
  input  [1:0]  io_ctrl_st_type,
  input  [2:0]  io_ctrl_ld_type,
  input  [1:0]  io_ctrl_wb_sel,
  input         io_ctrl_wb_en,
  input  [2:0]  io_ctrl_csr_cmd,
  input         io_ctrl_illegal
);
  wire  csr_clock; // @[Datapath.scala 23:23]
  wire  csr_reset; // @[Datapath.scala 23:23]
  wire  csr_io_stall; // @[Datapath.scala 23:23]
  wire [2:0] csr_io_cmd; // @[Datapath.scala 23:23]
  wire [31:0] csr_io_in; // @[Datapath.scala 23:23]
  wire [31:0] csr_io_out; // @[Datapath.scala 23:23]
  wire [31:0] csr_io_pc; // @[Datapath.scala 23:23]
  wire [31:0] csr_io_addr; // @[Datapath.scala 23:23]
  wire [31:0] csr_io_inst; // @[Datapath.scala 23:23]
  wire  csr_io_illegal; // @[Datapath.scala 23:23]
  wire [1:0] csr_io_st_type; // @[Datapath.scala 23:23]
  wire [2:0] csr_io_ld_type; // @[Datapath.scala 23:23]
  wire  csr_io_pc_check; // @[Datapath.scala 23:23]
  wire  csr_io_expt; // @[Datapath.scala 23:23]
  wire [31:0] csr_io_evec; // @[Datapath.scala 23:23]
  wire [31:0] csr_io_epc; // @[Datapath.scala 23:23]
  wire  regFile_clock; // @[Datapath.scala 24:23]
  wire [4:0] regFile_io_raddr1; // @[Datapath.scala 24:23]
  wire [4:0] regFile_io_raddr2; // @[Datapath.scala 24:23]
  wire [31:0] regFile_io_rdata1; // @[Datapath.scala 24:23]
  wire [31:0] regFile_io_rdata2; // @[Datapath.scala 24:23]
  wire  regFile_io_wen; // @[Datapath.scala 24:23]
  wire [4:0] regFile_io_waddr; // @[Datapath.scala 24:23]
  wire [31:0] regFile_io_wdata; // @[Datapath.scala 24:23]
  wire [31:0] alu_io_A; // @[Config.scala 13:50]
  wire [31:0] alu_io_B; // @[Config.scala 13:50]
  wire [3:0] alu_io_alu_op; // @[Config.scala 13:50]
  wire [31:0] alu_io_out; // @[Config.scala 13:50]
  wire [31:0] alu_io_sum; // @[Config.scala 13:50]
  wire [31:0] immGen_io_inst; // @[Config.scala 14:50]
  wire [2:0] immGen_io_sel; // @[Config.scala 14:50]
  wire [31:0] immGen_io_out; // @[Config.scala 14:50]
  wire [31:0] brCond_io_rs1; // @[Config.scala 15:50]
  wire [31:0] brCond_io_rs2; // @[Config.scala 15:50]
  wire [2:0] brCond_io_br_type; // @[Config.scala 15:50]
  wire  brCond_io_taken; // @[Config.scala 15:50]
  reg [31:0] fe_inst; // @[Datapath.scala 32:24]
  reg [31:0] _RAND_0;
  reg [32:0] fe_pc; // @[Datapath.scala 33:20]
  reg [63:0] _RAND_1;
  reg [31:0] ew_inst; // @[Datapath.scala 36:24]
  reg [31:0] _RAND_2;
  reg [32:0] ew_pc; // @[Datapath.scala 37:20]
  reg [63:0] _RAND_3;
  reg [31:0] ew_alu; // @[Datapath.scala 38:20]
  reg [31:0] _RAND_4;
  reg [31:0] csr_in; // @[Datapath.scala 39:20]
  reg [31:0] _RAND_5;
  reg [1:0] st_type; // @[Datapath.scala 42:21]
  reg [31:0] _RAND_6;
  reg [2:0] ld_type; // @[Datapath.scala 43:21]
  reg [31:0] _RAND_7;
  reg [1:0] wb_sel; // @[Datapath.scala 44:21]
  reg [31:0] _RAND_8;
  reg  wb_en; // @[Datapath.scala 45:21]
  reg [31:0] _RAND_9;
  reg [2:0] csr_cmd; // @[Datapath.scala 46:21]
  reg [31:0] _RAND_10;
  reg  illegal; // @[Datapath.scala 47:21]
  reg [31:0] _RAND_11;
  reg  pc_check; // @[Datapath.scala 48:21]
  reg [31:0] _RAND_12;
  reg  started; // @[Datapath.scala 51:24]
  reg [31:0] _RAND_13;
  reg [32:0] pc; // @[Datapath.scala 53:21]
  reg [63:0] _RAND_14;
  wire  _T_151; // @[Datapath.scala 52:15]
  wire  _T_153; // @[Datapath.scala 52:40]
  wire  stall; // @[Datapath.scala 52:37]
  wire [32:0] _T_156; // @[Datapath.scala 53:47]
  wire [32:0] _T_157; // @[Datapath.scala 53:47]
  wire [31:0] _T_158; // @[Datapath.scala 53:47]
  wire  _T_160; // @[Datapath.scala 55:33]
  wire  _T_161; // @[Datapath.scala 56:33]
  wire  _T_162; // @[Datapath.scala 56:44]
  wire [31:0] _T_164; // @[Datapath.scala 56:75]
  wire [32:0] _GEN_24; // @[Datapath.scala 56:82]
  wire [32:0] _T_166; // @[Datapath.scala 56:82]
  wire  _T_167; // @[Datapath.scala 57:33]
  wire [33:0] _T_169; // @[Datapath.scala 57:50]
  wire [32:0] _T_170; // @[Datapath.scala 57:50]
  wire [32:0] _T_171; // @[Datapath.scala 57:17]
  wire [32:0] _T_172; // @[Datapath.scala 56:17]
  wire [32:0] _T_173; // @[Datapath.scala 55:17]
  wire [32:0] _T_174; // @[Datapath.scala 54:32]
  wire [32:0] npc; // @[Datapath.scala 54:17]
  wire  _T_175; // @[Datapath.scala 58:26]
  wire  _T_176; // @[Datapath.scala 58:47]
  wire  _T_177; // @[Datapath.scala 58:66]
  wire [31:0] inst; // @[Datapath.scala 58:17]
  wire  _T_182; // @[Datapath.scala 63:30]
  wire [32:0] _GEN_0; // @[Datapath.scala 67:17]
  wire [31:0] _GEN_1; // @[Datapath.scala 67:17]
  wire [4:0] rs1_addr; // @[Datapath.scala 78:25]
  wire [4:0] rs2_addr; // @[Datapath.scala 79:25]
  wire [4:0] wb_rd_addr; // @[Datapath.scala 88:27]
  wire  _T_187; // @[Datapath.scala 89:37]
  wire  _T_188; // @[Datapath.scala 89:25]
  wire  _T_189; // @[Datapath.scala 89:54]
  wire  rs1hazard; // @[Datapath.scala 89:41]
  wire  _T_191; // @[Datapath.scala 90:37]
  wire  _T_192; // @[Datapath.scala 90:25]
  wire  _T_193; // @[Datapath.scala 90:54]
  wire  rs2hazard; // @[Datapath.scala 90:41]
  wire  _T_194; // @[Datapath.scala 91:24]
  wire  _T_195; // @[Datapath.scala 91:35]
  wire [31:0] rs1; // @[Datapath.scala 91:16]
  wire  _T_197; // @[Datapath.scala 92:35]
  wire [31:0] rs2; // @[Datapath.scala 92:16]
  wire [32:0] _T_199; // @[Datapath.scala 95:18]
  wire [31:0] _T_201; // @[Datapath.scala 96:18]
  wire [31:0] _T_202; // @[Datapath.scala 105:20]
  wire [31:0] _T_204; // @[Datapath.scala 105:48]
  wire [34:0] _GEN_25; // @[Datapath.scala 105:55]
  wire [34:0] daddr; // @[Datapath.scala 105:55]
  wire  _T_206; // @[Datapath.scala 106:27]
  wire [7:0] _GEN_26; // @[Datapath.scala 106:31]
  wire [7:0] _T_208; // @[Datapath.scala 106:31]
  wire  _T_209; // @[Datapath.scala 106:50]
  wire [3:0] _GEN_27; // @[Datapath.scala 106:54]
  wire [3:0] _T_211; // @[Datapath.scala 106:54]
  wire [7:0] _GEN_28; // @[Datapath.scala 106:38]
  wire [7:0] woffset; // @[Datapath.scala 106:38]
  wire  _T_215; // @[Datapath.scala 107:57]
  wire  _T_217; // @[Datapath.scala 107:80]
  wire  _T_218; // @[Datapath.scala 107:61]
  wire  _T_219; // @[Datapath.scala 107:37]
  wire [286:0] _GEN_29; // @[Datapath.scala 109:34]
  wire [286:0] _T_220; // @[Datapath.scala 109:34]
  wire [1:0] _T_221; // @[Datapath.scala 110:43]
  wire [1:0] _T_225; // @[Datapath.scala 113:36]
  wire [4:0] _T_226; // @[Datapath.scala 113:23]
  wire [3:0] _T_229; // @[Datapath.scala 114:23]
  wire  _T_230; // @[Mux.scala 46:19]
  wire [3:0] _T_231; // @[Mux.scala 46:16]
  wire  _T_232; // @[Mux.scala 46:19]
  wire [4:0] _T_233; // @[Mux.scala 46:16]
  wire  _T_234; // @[Mux.scala 46:19]
  wire [4:0] _T_235; // @[Mux.scala 46:16]
  wire  _T_239; // @[Datapath.scala 117:31]
  wire  _T_240; // @[Datapath.scala 117:21]
  wire  _T_250; // @[Datapath.scala 124:24]
  wire  _T_251; // @[Datapath.scala 124:21]
  wire  _T_252; // @[Datapath.scala 128:38]
  wire [31:0] _T_253; // @[Datapath.scala 128:21]
  wire [32:0] _GEN_2; // @[Datapath.scala 124:38]
  wire [31:0] _GEN_3; // @[Datapath.scala 124:38]
  wire [31:0] _GEN_4; // @[Datapath.scala 124:38]
  wire [31:0] _GEN_5; // @[Datapath.scala 124:38]
  wire [1:0] _GEN_6; // @[Datapath.scala 124:38]
  wire [2:0] _GEN_7; // @[Datapath.scala 124:38]
  wire [1:0] _GEN_8; // @[Datapath.scala 124:38]
  wire  _GEN_9; // @[Datapath.scala 124:38]
  wire [2:0] _GEN_10; // @[Datapath.scala 124:38]
  wire  _GEN_11; // @[Datapath.scala 124:38]
  wire  _GEN_12; // @[Datapath.scala 124:38]
  wire [1:0] _GEN_13; // @[Datapath.scala 117:47]
  wire [2:0] _GEN_14; // @[Datapath.scala 117:47]
  wire  _GEN_15; // @[Datapath.scala 117:47]
  wire [2:0] _GEN_16; // @[Datapath.scala 117:47]
  wire  _GEN_17; // @[Datapath.scala 117:47]
  wire  _GEN_18; // @[Datapath.scala 117:47]
  wire [32:0] _GEN_19; // @[Datapath.scala 117:47]
  wire [31:0] _GEN_20; // @[Datapath.scala 117:47]
  wire [31:0] _GEN_21; // @[Datapath.scala 117:47]
  wire [31:0] _GEN_22; // @[Datapath.scala 117:47]
  wire [1:0] _GEN_23; // @[Datapath.scala 117:47]
  wire  _T_255; // @[Datapath.scala 139:23]
  wire [7:0] _GEN_30; // @[Datapath.scala 139:27]
  wire [7:0] _T_257; // @[Datapath.scala 139:27]
  wire  _T_258; // @[Datapath.scala 139:42]
  wire [3:0] _GEN_31; // @[Datapath.scala 139:46]
  wire [3:0] _T_260; // @[Datapath.scala 139:46]
  wire [7:0] _GEN_32; // @[Datapath.scala 139:34]
  wire [7:0] loffset; // @[Datapath.scala 139:34]
  wire [31:0] lshift; // @[Datapath.scala 140:42]
  wire [32:0] _T_261; // @[Datapath.scala 141:61]
  wire [15:0] _T_262; // @[Datapath.scala 142:21]
  wire [15:0] _T_263; // @[Datapath.scala 142:29]
  wire [7:0] _T_264; // @[Datapath.scala 142:53]
  wire [7:0] _T_265; // @[Datapath.scala 142:60]
  wire [16:0] _T_267; // @[Datapath.scala 143:29]
  wire [8:0] _T_269; // @[Datapath.scala 143:60]
  wire  _T_270; // @[Mux.scala 46:19]
  wire [32:0] _T_271; // @[Mux.scala 46:16]
  wire  _T_272; // @[Mux.scala 46:19]
  wire [32:0] _T_273; // @[Mux.scala 46:16]
  wire  _T_274; // @[Mux.scala 46:19]
  wire [32:0] _T_275; // @[Mux.scala 46:16]
  wire  _T_276; // @[Mux.scala 46:19]
  wire [32:0] load; // @[Mux.scala 46:16]
  wire [32:0] _T_277; // @[Datapath.scala 159:43]
  wire [33:0] _T_279; // @[Datapath.scala 161:22]
  wire [32:0] _T_280; // @[Datapath.scala 161:22]
  wire [33:0] _T_281; // @[Datapath.scala 161:29]
  wire [32:0] _T_282; // @[Datapath.scala 162:26]
  wire  _T_283; // @[Mux.scala 46:19]
  wire [32:0] _T_284; // @[Mux.scala 46:16]
  wire  _T_285; // @[Mux.scala 46:19]
  wire [33:0] _T_286; // @[Mux.scala 46:16]
  wire  _T_287; // @[Mux.scala 46:19]
  wire [33:0] _T_288; // @[Mux.scala 46:16]
  wire [33:0] regWrite; // @[Datapath.scala 162:34]
  wire  _T_291; // @[Datapath.scala 164:29]
  wire  _T_294; // @[Datapath.scala 164:39]
  CSR csr ( // @[Datapath.scala 23:23]
    .clock(csr_clock),
    .reset(csr_reset),
    .io_stall(csr_io_stall),
    .io_cmd(csr_io_cmd),
    .io_in(csr_io_in),
    .io_out(csr_io_out),
    .io_pc(csr_io_pc),
    .io_addr(csr_io_addr),
    .io_inst(csr_io_inst),
    .io_illegal(csr_io_illegal),
    .io_st_type(csr_io_st_type),
    .io_ld_type(csr_io_ld_type),
    .io_pc_check(csr_io_pc_check),
    .io_expt(csr_io_expt),
    .io_evec(csr_io_evec),
    .io_epc(csr_io_epc)
  );
  RegFile regFile ( // @[Datapath.scala 24:23]
    .clock(regFile_clock),
    .io_raddr1(regFile_io_raddr1),
    .io_raddr2(regFile_io_raddr2),
    .io_rdata1(regFile_io_rdata1),
    .io_rdata2(regFile_io_rdata2),
    .io_wen(regFile_io_wen),
    .io_waddr(regFile_io_waddr),
    .io_wdata(regFile_io_wdata)
  );
  ALUArea alu ( // @[Config.scala 13:50]
    .io_A(alu_io_A),
    .io_B(alu_io_B),
    .io_alu_op(alu_io_alu_op),
    .io_out(alu_io_out),
    .io_sum(alu_io_sum)
  );
  ImmGenWire immGen ( // @[Config.scala 14:50]
    .io_inst(immGen_io_inst),
    .io_sel(immGen_io_sel),
    .io_out(immGen_io_out)
  );
  BrCondArea brCond ( // @[Config.scala 15:50]
    .io_rs1(brCond_io_rs1),
    .io_rs2(brCond_io_rs2),
    .io_br_type(brCond_io_br_type),
    .io_taken(brCond_io_taken)
  );
  assign _T_151 = io_icache_resp_valid == 1'h0; // @[Datapath.scala 52:15]
  assign _T_153 = io_dcache_resp_valid == 1'h0; // @[Datapath.scala 52:40]
  assign stall = _T_151 | _T_153; // @[Datapath.scala 52:37]
  assign _T_156 = 32'h200 - 32'h4; // @[Datapath.scala 53:47]
  assign _T_157 = $unsigned(_T_156); // @[Datapath.scala 53:47]
  assign _T_158 = _T_157[31:0]; // @[Datapath.scala 53:47]
  assign _T_160 = io_ctrl_pc_sel == 2'h3; // @[Datapath.scala 55:33]
  assign _T_161 = io_ctrl_pc_sel == 2'h1; // @[Datapath.scala 56:33]
  assign _T_162 = _T_161 | brCond_io_taken; // @[Datapath.scala 56:44]
  assign _T_164 = alu_io_sum >> 1'h1; // @[Datapath.scala 56:75]
  assign _GEN_24 = {{1'd0}, _T_164}; // @[Datapath.scala 56:82]
  assign _T_166 = _GEN_24 << 1'h1; // @[Datapath.scala 56:82]
  assign _T_167 = io_ctrl_pc_sel == 2'h2; // @[Datapath.scala 57:33]
  assign _T_169 = pc + 33'h4; // @[Datapath.scala 57:50]
  assign _T_170 = _T_169[32:0]; // @[Datapath.scala 57:50]
  assign _T_171 = _T_167 ? pc : _T_170; // @[Datapath.scala 57:17]
  assign _T_172 = _T_162 ? _T_166 : _T_171; // @[Datapath.scala 56:17]
  assign _T_173 = _T_160 ? {{1'd0}, csr_io_epc} : _T_172; // @[Datapath.scala 55:17]
  assign _T_174 = csr_io_expt ? {{1'd0}, csr_io_evec} : _T_173; // @[Datapath.scala 54:32]
  assign npc = stall ? pc : _T_174; // @[Datapath.scala 54:17]
  assign _T_175 = started | io_ctrl_inst_kill; // @[Datapath.scala 58:26]
  assign _T_176 = _T_175 | brCond_io_taken; // @[Datapath.scala 58:47]
  assign _T_177 = _T_176 | csr_io_expt; // @[Datapath.scala 58:66]
  assign inst = _T_177 ? 32'h13 : io_icache_resp_bits_data; // @[Datapath.scala 58:17]
  assign _T_182 = stall == 1'h0; // @[Datapath.scala 63:30]
  assign _GEN_0 = _T_182 ? pc : fe_pc; // @[Datapath.scala 67:17]
  assign _GEN_1 = _T_182 ? inst : fe_inst; // @[Datapath.scala 67:17]
  assign rs1_addr = fe_inst[19:15]; // @[Datapath.scala 78:25]
  assign rs2_addr = fe_inst[24:20]; // @[Datapath.scala 79:25]
  assign wb_rd_addr = ew_inst[11:7]; // @[Datapath.scala 88:27]
  assign _T_187 = rs1_addr != 5'h0; // @[Datapath.scala 89:37]
  assign _T_188 = wb_en & _T_187; // @[Datapath.scala 89:25]
  assign _T_189 = rs1_addr == wb_rd_addr; // @[Datapath.scala 89:54]
  assign rs1hazard = _T_188 & _T_189; // @[Datapath.scala 89:41]
  assign _T_191 = rs2_addr != 5'h0; // @[Datapath.scala 90:37]
  assign _T_192 = wb_en & _T_191; // @[Datapath.scala 90:25]
  assign _T_193 = rs2_addr == wb_rd_addr; // @[Datapath.scala 90:54]
  assign rs2hazard = _T_192 & _T_193; // @[Datapath.scala 90:41]
  assign _T_194 = wb_sel == 2'h0; // @[Datapath.scala 91:24]
  assign _T_195 = _T_194 & rs1hazard; // @[Datapath.scala 91:35]
  assign rs1 = _T_195 ? ew_alu : regFile_io_rdata1; // @[Datapath.scala 91:16]
  assign _T_197 = _T_194 & rs2hazard; // @[Datapath.scala 92:35]
  assign rs2 = _T_197 ? ew_alu : regFile_io_rdata2; // @[Datapath.scala 92:16]
  assign _T_199 = io_ctrl_A_sel ? {{1'd0}, rs1} : fe_pc; // @[Datapath.scala 95:18]
  assign _T_201 = io_ctrl_B_sel ? rs2 : immGen_io_out; // @[Datapath.scala 96:18]
  assign _T_202 = stall ? ew_alu : alu_io_sum; // @[Datapath.scala 105:20]
  assign _T_204 = _T_202 >> 2'h2; // @[Datapath.scala 105:48]
  assign _GEN_25 = {{3'd0}, _T_204}; // @[Datapath.scala 105:55]
  assign daddr = _GEN_25 << 2'h2; // @[Datapath.scala 105:55]
  assign _T_206 = alu_io_sum[1]; // @[Datapath.scala 106:27]
  assign _GEN_26 = {{7'd0}, _T_206}; // @[Datapath.scala 106:31]
  assign _T_208 = _GEN_26 << 3'h4; // @[Datapath.scala 106:31]
  assign _T_209 = alu_io_sum[0]; // @[Datapath.scala 106:50]
  assign _GEN_27 = {{3'd0}, _T_209}; // @[Datapath.scala 106:54]
  assign _T_211 = _GEN_27 << 2'h3; // @[Datapath.scala 106:54]
  assign _GEN_28 = {{4'd0}, _T_211}; // @[Datapath.scala 106:38]
  assign woffset = _T_208 | _GEN_28; // @[Datapath.scala 106:38]
  assign _T_215 = io_ctrl_st_type != 2'h0; // @[Datapath.scala 107:57]
  assign _T_217 = io_ctrl_ld_type != 3'h0; // @[Datapath.scala 107:80]
  assign _T_218 = _T_215 | _T_217; // @[Datapath.scala 107:61]
  assign _T_219 = _T_182 & _T_218; // @[Datapath.scala 107:37]
  assign _GEN_29 = {{255'd0}, rs2}; // @[Datapath.scala 109:34]
  assign _T_220 = _GEN_29 << woffset; // @[Datapath.scala 109:34]
  assign _T_221 = stall ? st_type : io_ctrl_st_type; // @[Datapath.scala 110:43]
  assign _T_225 = alu_io_sum[1:0]; // @[Datapath.scala 113:36]
  assign _T_226 = 5'h3 << _T_225; // @[Datapath.scala 113:23]
  assign _T_229 = 4'h1 << _T_225; // @[Datapath.scala 114:23]
  assign _T_230 = 2'h3 == _T_221; // @[Mux.scala 46:19]
  assign _T_231 = _T_230 ? _T_229 : 4'h0; // @[Mux.scala 46:16]
  assign _T_232 = 2'h2 == _T_221; // @[Mux.scala 46:19]
  assign _T_233 = _T_232 ? _T_226 : {{1'd0}, _T_231}; // @[Mux.scala 46:16]
  assign _T_234 = 2'h1 == _T_221; // @[Mux.scala 46:19]
  assign _T_235 = _T_234 ? 5'hf : _T_233; // @[Mux.scala 46:16]
  assign _T_239 = _T_182 & csr_io_expt; // @[Datapath.scala 117:31]
  assign _T_240 = reset | _T_239; // @[Datapath.scala 117:21]
  assign _T_250 = csr_io_expt == 1'h0; // @[Datapath.scala 124:24]
  assign _T_251 = _T_182 & _T_250; // @[Datapath.scala 124:21]
  assign _T_252 = io_ctrl_imm_sel == 3'h6; // @[Datapath.scala 128:38]
  assign _T_253 = _T_252 ? immGen_io_out : rs1; // @[Datapath.scala 128:21]
  assign _GEN_2 = _T_251 ? fe_pc : ew_pc; // @[Datapath.scala 124:38]
  assign _GEN_3 = _T_251 ? fe_inst : ew_inst; // @[Datapath.scala 124:38]
  assign _GEN_4 = _T_251 ? alu_io_out : ew_alu; // @[Datapath.scala 124:38]
  assign _GEN_5 = _T_251 ? _T_253 : csr_in; // @[Datapath.scala 124:38]
  assign _GEN_6 = _T_251 ? io_ctrl_st_type : st_type; // @[Datapath.scala 124:38]
  assign _GEN_7 = _T_251 ? io_ctrl_ld_type : ld_type; // @[Datapath.scala 124:38]
  assign _GEN_8 = _T_251 ? io_ctrl_wb_sel : wb_sel; // @[Datapath.scala 124:38]
  assign _GEN_9 = _T_251 ? io_ctrl_wb_en : wb_en; // @[Datapath.scala 124:38]
  assign _GEN_10 = _T_251 ? io_ctrl_csr_cmd : csr_cmd; // @[Datapath.scala 124:38]
  assign _GEN_11 = _T_251 ? io_ctrl_illegal : illegal; // @[Datapath.scala 124:38]
  assign _GEN_12 = _T_251 ? _T_161 : pc_check; // @[Datapath.scala 124:38]
  assign _GEN_13 = _T_240 ? 2'h0 : _GEN_6; // @[Datapath.scala 117:47]
  assign _GEN_14 = _T_240 ? 3'h0 : _GEN_7; // @[Datapath.scala 117:47]
  assign _GEN_15 = _T_240 ? 1'h0 : _GEN_9; // @[Datapath.scala 117:47]
  assign _GEN_16 = _T_240 ? 3'h0 : _GEN_10; // @[Datapath.scala 117:47]
  assign _GEN_17 = _T_240 ? 1'h0 : _GEN_11; // @[Datapath.scala 117:47]
  assign _GEN_18 = _T_240 ? 1'h0 : _GEN_12; // @[Datapath.scala 117:47]
  assign _GEN_19 = _T_240 ? ew_pc : _GEN_2; // @[Datapath.scala 117:47]
  assign _GEN_20 = _T_240 ? ew_inst : _GEN_3; // @[Datapath.scala 117:47]
  assign _GEN_21 = _T_240 ? ew_alu : _GEN_4; // @[Datapath.scala 117:47]
  assign _GEN_22 = _T_240 ? csr_in : _GEN_5; // @[Datapath.scala 117:47]
  assign _GEN_23 = _T_240 ? wb_sel : _GEN_8; // @[Datapath.scala 117:47]
  assign _T_255 = ew_alu[1]; // @[Datapath.scala 139:23]
  assign _GEN_30 = {{7'd0}, _T_255}; // @[Datapath.scala 139:27]
  assign _T_257 = _GEN_30 << 3'h4; // @[Datapath.scala 139:27]
  assign _T_258 = ew_alu[0]; // @[Datapath.scala 139:42]
  assign _GEN_31 = {{3'd0}, _T_258}; // @[Datapath.scala 139:46]
  assign _T_260 = _GEN_31 << 2'h3; // @[Datapath.scala 139:46]
  assign _GEN_32 = {{4'd0}, _T_260}; // @[Datapath.scala 139:34]
  assign loffset = _T_257 | _GEN_32; // @[Datapath.scala 139:34]
  assign lshift = io_dcache_resp_bits_data >> loffset; // @[Datapath.scala 140:42]
  assign _T_261 = {1'b0,$signed(io_dcache_resp_bits_data)}; // @[Datapath.scala 141:61]
  assign _T_262 = lshift[15:0]; // @[Datapath.scala 142:21]
  assign _T_263 = $signed(_T_262); // @[Datapath.scala 142:29]
  assign _T_264 = lshift[7:0]; // @[Datapath.scala 142:53]
  assign _T_265 = $signed(_T_264); // @[Datapath.scala 142:60]
  assign _T_267 = {1'b0,$signed(_T_262)}; // @[Datapath.scala 143:29]
  assign _T_269 = {1'b0,$signed(_T_264)}; // @[Datapath.scala 143:60]
  assign _T_270 = 3'h5 == ld_type; // @[Mux.scala 46:19]
  assign _T_271 = _T_270 ? $signed({{24{_T_269[8]}},_T_269}) : $signed(_T_261); // @[Mux.scala 46:16]
  assign _T_272 = 3'h4 == ld_type; // @[Mux.scala 46:19]
  assign _T_273 = _T_272 ? $signed({{16{_T_267[16]}},_T_267}) : $signed(_T_271); // @[Mux.scala 46:16]
  assign _T_274 = 3'h3 == ld_type; // @[Mux.scala 46:19]
  assign _T_275 = _T_274 ? $signed({{25{_T_265[7]}},_T_265}) : $signed(_T_273); // @[Mux.scala 46:16]
  assign _T_276 = 3'h2 == ld_type; // @[Mux.scala 46:19]
  assign load = _T_276 ? $signed({{17{_T_263[15]}},_T_263}) : $signed(_T_275); // @[Mux.scala 46:16]
  assign _T_277 = {1'b0,$signed(ew_alu)}; // @[Datapath.scala 159:43]
  assign _T_279 = ew_pc + 33'h4; // @[Datapath.scala 161:22]
  assign _T_280 = _T_279[32:0]; // @[Datapath.scala 161:22]
  assign _T_281 = {1'b0,$signed(_T_280)}; // @[Datapath.scala 161:29]
  assign _T_282 = {1'b0,$signed(csr_io_out)}; // @[Datapath.scala 162:26]
  assign _T_283 = 2'h3 == wb_sel; // @[Mux.scala 46:19]
  assign _T_284 = _T_283 ? $signed(_T_282) : $signed(_T_277); // @[Mux.scala 46:16]
  assign _T_285 = 2'h2 == wb_sel; // @[Mux.scala 46:19]
  assign _T_286 = _T_285 ? $signed(_T_281) : $signed({{1{_T_284[32]}},_T_284}); // @[Mux.scala 46:16]
  assign _T_287 = 2'h1 == wb_sel; // @[Mux.scala 46:19]
  assign _T_288 = _T_287 ? $signed({{1{load[32]}},load}) : $signed(_T_286); // @[Mux.scala 46:16]
  assign regWrite = $unsigned(_T_288); // @[Datapath.scala 162:34]
  assign _T_291 = wb_en & _T_182; // @[Datapath.scala 164:29]
  assign _T_294 = _T_291 & _T_250; // @[Datapath.scala 164:39]
  assign io_icache_req_valid = _T_182;
  assign io_icache_req_bits_addr = npc[31:0];
  assign io_dcache_abort = csr_io_expt;
  assign io_dcache_req_valid = _T_219;
  assign io_dcache_req_bits_addr = daddr[31:0];
  assign io_dcache_req_bits_data = _T_220[31:0];
  assign io_dcache_req_bits_mask = _T_235[3:0];
  assign io_ctrl_inst = fe_inst;
  assign csr_clock = clock;
  assign csr_reset = reset;
  assign csr_io_stall = stall;
  assign csr_io_cmd = csr_cmd;
  assign csr_io_in = csr_in;
  assign csr_io_pc = ew_pc[31:0];
  assign csr_io_addr = ew_alu;
  assign csr_io_inst = ew_inst;
  assign csr_io_illegal = illegal;
  assign csr_io_st_type = st_type;
  assign csr_io_ld_type = ld_type;
  assign csr_io_pc_check = pc_check;
  assign regFile_clock = clock;
  assign regFile_io_raddr1 = rs1_addr;
  assign regFile_io_raddr2 = rs2_addr;
  assign regFile_io_wen = _T_294;
  assign regFile_io_waddr = wb_rd_addr;
  assign regFile_io_wdata = regWrite[31:0];
  assign alu_io_A = _T_199[31:0];
  assign alu_io_B = _T_201;
  assign alu_io_alu_op = io_ctrl_alu_op;
  assign immGen_io_inst = fe_inst;
  assign immGen_io_sel = io_ctrl_imm_sel;
  assign brCond_io_rs1 = rs1;
  assign brCond_io_rs2 = rs2;
  assign brCond_io_br_type = io_ctrl_br_type;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  fe_inst = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {2{$random}};
  fe_pc = _RAND_1[32:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  ew_inst = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {2{$random}};
  ew_pc = _RAND_3[32:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{$random}};
  ew_alu = _RAND_4[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{$random}};
  csr_in = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{$random}};
  st_type = _RAND_6[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{$random}};
  ld_type = _RAND_7[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{$random}};
  wb_sel = _RAND_8[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_9 = {1{$random}};
  wb_en = _RAND_9[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{$random}};
  csr_cmd = _RAND_10[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_11 = {1{$random}};
  illegal = _RAND_11[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{$random}};
  pc_check = _RAND_12[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_13 = {1{$random}};
  started = _RAND_13[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {2{$random}};
  pc = _RAND_14[32:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      fe_inst <= 32'h13;
    end else begin
      if (_T_182) begin
        if (_T_177) begin
          fe_inst <= 32'h13;
        end else begin
          fe_inst <= io_icache_resp_bits_data;
        end
      end
    end
    if (_T_182) begin
      fe_pc <= pc;
    end
    if (reset) begin
      ew_inst <= 32'h13;
    end else begin
      if (!(_T_240)) begin
        if (_T_251) begin
          ew_inst <= fe_inst;
        end
      end
    end
    if (!(_T_240)) begin
      if (_T_251) begin
        ew_pc <= fe_pc;
      end
    end
    if (!(_T_240)) begin
      if (_T_251) begin
        ew_alu <= alu_io_out;
      end
    end
    if (!(_T_240)) begin
      if (_T_251) begin
        if (_T_252) begin
          csr_in <= immGen_io_out;
        end else begin
          if (_T_195) begin
            csr_in <= ew_alu;
          end else begin
            csr_in <= regFile_io_rdata1;
          end
        end
      end
    end
    if (_T_240) begin
      st_type <= 2'h0;
    end else begin
      if (_T_251) begin
        st_type <= io_ctrl_st_type;
      end
    end
    if (_T_240) begin
      ld_type <= 3'h0;
    end else begin
      if (_T_251) begin
        ld_type <= io_ctrl_ld_type;
      end
    end
    if (!(_T_240)) begin
      if (_T_251) begin
        wb_sel <= io_ctrl_wb_sel;
      end
    end
    if (_T_240) begin
      wb_en <= 1'h0;
    end else begin
      if (_T_251) begin
        wb_en <= io_ctrl_wb_en;
      end
    end
    if (_T_240) begin
      csr_cmd <= 3'h0;
    end else begin
      if (_T_251) begin
        csr_cmd <= io_ctrl_csr_cmd;
      end
    end
    if (_T_240) begin
      illegal <= 1'h0;
    end else begin
      if (_T_251) begin
        illegal <= io_ctrl_illegal;
      end
    end
    if (_T_240) begin
      pc_check <= 1'h0;
    end else begin
      if (_T_251) begin
        pc_check <= _T_161;
      end
    end
    started <= reset;
    if (reset) begin
      pc <= {{1'd0}, _T_158};
    end else begin
      if (!(stall)) begin
        if (csr_io_expt) begin
          pc <= {{1'd0}, csr_io_evec};
        end else begin
          if (_T_160) begin
            pc <= {{1'd0}, csr_io_epc};
          end else begin
            if (_T_162) begin
              pc <= _T_166;
            end else begin
              if (!(_T_167)) begin
                pc <= _T_170;
              end
            end
          end
        end
      end
    end
  end
endmodule
module Control(
  input  [31:0] io_inst,
  output [1:0]  io_pc_sel,
  output        io_inst_kill,
  output        io_A_sel,
  output        io_B_sel,
  output [2:0]  io_imm_sel,
  output [3:0]  io_alu_op,
  output [2:0]  io_br_type,
  output [1:0]  io_st_type,
  output [2:0]  io_ld_type,
  output [1:0]  io_wb_sel,
  output        io_wb_en,
  output [2:0]  io_csr_cmd,
  output        io_illegal
);
  wire [31:0] _T_35; // @[Lookup.scala 9:38]
  wire  _T_36; // @[Lookup.scala 9:38]
  wire  _T_40; // @[Lookup.scala 9:38]
  wire  _T_44; // @[Lookup.scala 9:38]
  wire [31:0] _T_47; // @[Lookup.scala 9:38]
  wire  _T_48; // @[Lookup.scala 9:38]
  wire  _T_52; // @[Lookup.scala 9:38]
  wire  _T_56; // @[Lookup.scala 9:38]
  wire  _T_60; // @[Lookup.scala 9:38]
  wire  _T_64; // @[Lookup.scala 9:38]
  wire  _T_68; // @[Lookup.scala 9:38]
  wire  _T_72; // @[Lookup.scala 9:38]
  wire  _T_76; // @[Lookup.scala 9:38]
  wire  _T_80; // @[Lookup.scala 9:38]
  wire  _T_84; // @[Lookup.scala 9:38]
  wire  _T_88; // @[Lookup.scala 9:38]
  wire  _T_92; // @[Lookup.scala 9:38]
  wire  _T_96; // @[Lookup.scala 9:38]
  wire  _T_100; // @[Lookup.scala 9:38]
  wire  _T_104; // @[Lookup.scala 9:38]
  wire  _T_108; // @[Lookup.scala 9:38]
  wire  _T_112; // @[Lookup.scala 9:38]
  wire  _T_116; // @[Lookup.scala 9:38]
  wire  _T_120; // @[Lookup.scala 9:38]
  wire  _T_124; // @[Lookup.scala 9:38]
  wire  _T_128; // @[Lookup.scala 9:38]
  wire [31:0] _T_131; // @[Lookup.scala 9:38]
  wire  _T_132; // @[Lookup.scala 9:38]
  wire  _T_136; // @[Lookup.scala 9:38]
  wire  _T_140; // @[Lookup.scala 9:38]
  wire  _T_144; // @[Lookup.scala 9:38]
  wire  _T_148; // @[Lookup.scala 9:38]
  wire  _T_152; // @[Lookup.scala 9:38]
  wire  _T_156; // @[Lookup.scala 9:38]
  wire  _T_160; // @[Lookup.scala 9:38]
  wire  _T_164; // @[Lookup.scala 9:38]
  wire  _T_168; // @[Lookup.scala 9:38]
  wire  _T_172; // @[Lookup.scala 9:38]
  wire  _T_176; // @[Lookup.scala 9:38]
  wire  _T_180; // @[Lookup.scala 9:38]
  wire [31:0] _T_183; // @[Lookup.scala 9:38]
  wire  _T_184; // @[Lookup.scala 9:38]
  wire  _T_188; // @[Lookup.scala 9:38]
  wire  _T_192; // @[Lookup.scala 9:38]
  wire  _T_196; // @[Lookup.scala 9:38]
  wire  _T_200; // @[Lookup.scala 9:38]
  wire  _T_204; // @[Lookup.scala 9:38]
  wire  _T_208; // @[Lookup.scala 9:38]
  wire  _T_212; // @[Lookup.scala 9:38]
  wire  _T_216; // @[Lookup.scala 9:38]
  wire  _T_220; // @[Lookup.scala 9:38]
  wire  _T_224; // @[Lookup.scala 9:38]
  wire  _T_228; // @[Lookup.scala 9:38]
  wire [1:0] _T_230; // @[Lookup.scala 11:37]
  wire [1:0] _T_231; // @[Lookup.scala 11:37]
  wire [1:0] _T_232; // @[Lookup.scala 11:37]
  wire [1:0] _T_233; // @[Lookup.scala 11:37]
  wire [1:0] _T_234; // @[Lookup.scala 11:37]
  wire [1:0] _T_235; // @[Lookup.scala 11:37]
  wire [1:0] _T_236; // @[Lookup.scala 11:37]
  wire [1:0] _T_237; // @[Lookup.scala 11:37]
  wire [1:0] _T_238; // @[Lookup.scala 11:37]
  wire [1:0] _T_239; // @[Lookup.scala 11:37]
  wire [1:0] _T_240; // @[Lookup.scala 11:37]
  wire [1:0] _T_241; // @[Lookup.scala 11:37]
  wire [1:0] _T_242; // @[Lookup.scala 11:37]
  wire [1:0] _T_243; // @[Lookup.scala 11:37]
  wire [1:0] _T_244; // @[Lookup.scala 11:37]
  wire [1:0] _T_245; // @[Lookup.scala 11:37]
  wire [1:0] _T_246; // @[Lookup.scala 11:37]
  wire [1:0] _T_247; // @[Lookup.scala 11:37]
  wire [1:0] _T_248; // @[Lookup.scala 11:37]
  wire [1:0] _T_249; // @[Lookup.scala 11:37]
  wire [1:0] _T_250; // @[Lookup.scala 11:37]
  wire [1:0] _T_251; // @[Lookup.scala 11:37]
  wire [1:0] _T_252; // @[Lookup.scala 11:37]
  wire [1:0] _T_253; // @[Lookup.scala 11:37]
  wire [1:0] _T_254; // @[Lookup.scala 11:37]
  wire [1:0] _T_255; // @[Lookup.scala 11:37]
  wire [1:0] _T_256; // @[Lookup.scala 11:37]
  wire [1:0] _T_257; // @[Lookup.scala 11:37]
  wire [1:0] _T_258; // @[Lookup.scala 11:37]
  wire [1:0] _T_259; // @[Lookup.scala 11:37]
  wire [1:0] _T_260; // @[Lookup.scala 11:37]
  wire [1:0] _T_261; // @[Lookup.scala 11:37]
  wire [1:0] _T_262; // @[Lookup.scala 11:37]
  wire [1:0] _T_263; // @[Lookup.scala 11:37]
  wire [1:0] _T_264; // @[Lookup.scala 11:37]
  wire [1:0] _T_265; // @[Lookup.scala 11:37]
  wire [1:0] _T_266; // @[Lookup.scala 11:37]
  wire [1:0] _T_267; // @[Lookup.scala 11:37]
  wire [1:0] _T_268; // @[Lookup.scala 11:37]
  wire [1:0] _T_269; // @[Lookup.scala 11:37]
  wire [1:0] _T_270; // @[Lookup.scala 11:37]
  wire [1:0] _T_271; // @[Lookup.scala 11:37]
  wire [1:0] _T_272; // @[Lookup.scala 11:37]
  wire [1:0] _T_273; // @[Lookup.scala 11:37]
  wire [1:0] _T_274; // @[Lookup.scala 11:37]
  wire [1:0] _T_275; // @[Lookup.scala 11:37]
  wire [1:0] _T_276; // @[Lookup.scala 11:37]
  wire [1:0] ctrlSignals_0; // @[Lookup.scala 11:37]
  wire  _T_285; // @[Lookup.scala 11:37]
  wire  _T_286; // @[Lookup.scala 11:37]
  wire  _T_287; // @[Lookup.scala 11:37]
  wire  _T_288; // @[Lookup.scala 11:37]
  wire  _T_289; // @[Lookup.scala 11:37]
  wire  _T_290; // @[Lookup.scala 11:37]
  wire  _T_291; // @[Lookup.scala 11:37]
  wire  _T_292; // @[Lookup.scala 11:37]
  wire  _T_293; // @[Lookup.scala 11:37]
  wire  _T_294; // @[Lookup.scala 11:37]
  wire  _T_295; // @[Lookup.scala 11:37]
  wire  _T_296; // @[Lookup.scala 11:37]
  wire  _T_297; // @[Lookup.scala 11:37]
  wire  _T_298; // @[Lookup.scala 11:37]
  wire  _T_299; // @[Lookup.scala 11:37]
  wire  _T_300; // @[Lookup.scala 11:37]
  wire  _T_301; // @[Lookup.scala 11:37]
  wire  _T_302; // @[Lookup.scala 11:37]
  wire  _T_303; // @[Lookup.scala 11:37]
  wire  _T_304; // @[Lookup.scala 11:37]
  wire  _T_305; // @[Lookup.scala 11:37]
  wire  _T_306; // @[Lookup.scala 11:37]
  wire  _T_307; // @[Lookup.scala 11:37]
  wire  _T_308; // @[Lookup.scala 11:37]
  wire  _T_309; // @[Lookup.scala 11:37]
  wire  _T_310; // @[Lookup.scala 11:37]
  wire  _T_311; // @[Lookup.scala 11:37]
  wire  _T_312; // @[Lookup.scala 11:37]
  wire  _T_313; // @[Lookup.scala 11:37]
  wire  _T_314; // @[Lookup.scala 11:37]
  wire  _T_315; // @[Lookup.scala 11:37]
  wire  _T_316; // @[Lookup.scala 11:37]
  wire  _T_317; // @[Lookup.scala 11:37]
  wire  _T_318; // @[Lookup.scala 11:37]
  wire  _T_319; // @[Lookup.scala 11:37]
  wire  _T_320; // @[Lookup.scala 11:37]
  wire  _T_321; // @[Lookup.scala 11:37]
  wire  _T_322; // @[Lookup.scala 11:37]
  wire  _T_323; // @[Lookup.scala 11:37]
  wire  _T_324; // @[Lookup.scala 11:37]
  wire  ctrlSignals_1; // @[Lookup.scala 11:37]
  wire  _T_338; // @[Lookup.scala 11:37]
  wire  _T_339; // @[Lookup.scala 11:37]
  wire  _T_340; // @[Lookup.scala 11:37]
  wire  _T_341; // @[Lookup.scala 11:37]
  wire  _T_342; // @[Lookup.scala 11:37]
  wire  _T_343; // @[Lookup.scala 11:37]
  wire  _T_344; // @[Lookup.scala 11:37]
  wire  _T_345; // @[Lookup.scala 11:37]
  wire  _T_346; // @[Lookup.scala 11:37]
  wire  _T_347; // @[Lookup.scala 11:37]
  wire  _T_348; // @[Lookup.scala 11:37]
  wire  _T_349; // @[Lookup.scala 11:37]
  wire  _T_350; // @[Lookup.scala 11:37]
  wire  _T_351; // @[Lookup.scala 11:37]
  wire  _T_352; // @[Lookup.scala 11:37]
  wire  _T_353; // @[Lookup.scala 11:37]
  wire  _T_354; // @[Lookup.scala 11:37]
  wire  _T_355; // @[Lookup.scala 11:37]
  wire  _T_356; // @[Lookup.scala 11:37]
  wire  _T_357; // @[Lookup.scala 11:37]
  wire  _T_358; // @[Lookup.scala 11:37]
  wire  _T_359; // @[Lookup.scala 11:37]
  wire  _T_360; // @[Lookup.scala 11:37]
  wire  _T_361; // @[Lookup.scala 11:37]
  wire  _T_362; // @[Lookup.scala 11:37]
  wire  _T_363; // @[Lookup.scala 11:37]
  wire  _T_364; // @[Lookup.scala 11:37]
  wire  _T_365; // @[Lookup.scala 11:37]
  wire  _T_366; // @[Lookup.scala 11:37]
  wire  _T_367; // @[Lookup.scala 11:37]
  wire  _T_368; // @[Lookup.scala 11:37]
  wire  _T_369; // @[Lookup.scala 11:37]
  wire  _T_370; // @[Lookup.scala 11:37]
  wire  _T_371; // @[Lookup.scala 11:37]
  wire  _T_372; // @[Lookup.scala 11:37]
  wire  ctrlSignals_2; // @[Lookup.scala 11:37]
  wire [2:0] _T_377; // @[Lookup.scala 11:37]
  wire [2:0] _T_378; // @[Lookup.scala 11:37]
  wire [2:0] _T_379; // @[Lookup.scala 11:37]
  wire [2:0] _T_380; // @[Lookup.scala 11:37]
  wire [2:0] _T_381; // @[Lookup.scala 11:37]
  wire [2:0] _T_382; // @[Lookup.scala 11:37]
  wire [2:0] _T_383; // @[Lookup.scala 11:37]
  wire [2:0] _T_384; // @[Lookup.scala 11:37]
  wire [2:0] _T_385; // @[Lookup.scala 11:37]
  wire [2:0] _T_386; // @[Lookup.scala 11:37]
  wire [2:0] _T_387; // @[Lookup.scala 11:37]
  wire [2:0] _T_388; // @[Lookup.scala 11:37]
  wire [2:0] _T_389; // @[Lookup.scala 11:37]
  wire [2:0] _T_390; // @[Lookup.scala 11:37]
  wire [2:0] _T_391; // @[Lookup.scala 11:37]
  wire [2:0] _T_392; // @[Lookup.scala 11:37]
  wire [2:0] _T_393; // @[Lookup.scala 11:37]
  wire [2:0] _T_394; // @[Lookup.scala 11:37]
  wire [2:0] _T_395; // @[Lookup.scala 11:37]
  wire [2:0] _T_396; // @[Lookup.scala 11:37]
  wire [2:0] _T_397; // @[Lookup.scala 11:37]
  wire [2:0] _T_398; // @[Lookup.scala 11:37]
  wire [2:0] _T_399; // @[Lookup.scala 11:37]
  wire [2:0] _T_400; // @[Lookup.scala 11:37]
  wire [2:0] _T_401; // @[Lookup.scala 11:37]
  wire [2:0] _T_402; // @[Lookup.scala 11:37]
  wire [2:0] _T_403; // @[Lookup.scala 11:37]
  wire [2:0] _T_404; // @[Lookup.scala 11:37]
  wire [2:0] _T_405; // @[Lookup.scala 11:37]
  wire [2:0] _T_406; // @[Lookup.scala 11:37]
  wire [2:0] _T_407; // @[Lookup.scala 11:37]
  wire [2:0] _T_408; // @[Lookup.scala 11:37]
  wire [2:0] _T_409; // @[Lookup.scala 11:37]
  wire [2:0] _T_410; // @[Lookup.scala 11:37]
  wire [2:0] _T_411; // @[Lookup.scala 11:37]
  wire [2:0] _T_412; // @[Lookup.scala 11:37]
  wire [2:0] _T_413; // @[Lookup.scala 11:37]
  wire [2:0] _T_414; // @[Lookup.scala 11:37]
  wire [2:0] _T_415; // @[Lookup.scala 11:37]
  wire [2:0] _T_416; // @[Lookup.scala 11:37]
  wire [2:0] _T_417; // @[Lookup.scala 11:37]
  wire [2:0] _T_418; // @[Lookup.scala 11:37]
  wire [2:0] _T_419; // @[Lookup.scala 11:37]
  wire [2:0] _T_420; // @[Lookup.scala 11:37]
  wire [2:0] ctrlSignals_3; // @[Lookup.scala 11:37]
  wire [3:0] _T_428; // @[Lookup.scala 11:37]
  wire [3:0] _T_429; // @[Lookup.scala 11:37]
  wire [3:0] _T_430; // @[Lookup.scala 11:37]
  wire [3:0] _T_431; // @[Lookup.scala 11:37]
  wire [3:0] _T_432; // @[Lookup.scala 11:37]
  wire [3:0] _T_433; // @[Lookup.scala 11:37]
  wire [3:0] _T_434; // @[Lookup.scala 11:37]
  wire [3:0] _T_435; // @[Lookup.scala 11:37]
  wire [3:0] _T_436; // @[Lookup.scala 11:37]
  wire [3:0] _T_437; // @[Lookup.scala 11:37]
  wire [3:0] _T_438; // @[Lookup.scala 11:37]
  wire [3:0] _T_439; // @[Lookup.scala 11:37]
  wire [3:0] _T_440; // @[Lookup.scala 11:37]
  wire [3:0] _T_441; // @[Lookup.scala 11:37]
  wire [3:0] _T_442; // @[Lookup.scala 11:37]
  wire [3:0] _T_443; // @[Lookup.scala 11:37]
  wire [3:0] _T_444; // @[Lookup.scala 11:37]
  wire [3:0] _T_445; // @[Lookup.scala 11:37]
  wire [3:0] _T_446; // @[Lookup.scala 11:37]
  wire [3:0] _T_447; // @[Lookup.scala 11:37]
  wire [3:0] _T_448; // @[Lookup.scala 11:37]
  wire [3:0] _T_449; // @[Lookup.scala 11:37]
  wire [3:0] _T_450; // @[Lookup.scala 11:37]
  wire [3:0] _T_451; // @[Lookup.scala 11:37]
  wire [3:0] _T_452; // @[Lookup.scala 11:37]
  wire [3:0] _T_453; // @[Lookup.scala 11:37]
  wire [3:0] _T_454; // @[Lookup.scala 11:37]
  wire [3:0] _T_455; // @[Lookup.scala 11:37]
  wire [3:0] _T_456; // @[Lookup.scala 11:37]
  wire [3:0] _T_457; // @[Lookup.scala 11:37]
  wire [3:0] _T_458; // @[Lookup.scala 11:37]
  wire [3:0] _T_459; // @[Lookup.scala 11:37]
  wire [3:0] _T_460; // @[Lookup.scala 11:37]
  wire [3:0] _T_461; // @[Lookup.scala 11:37]
  wire [3:0] _T_462; // @[Lookup.scala 11:37]
  wire [3:0] _T_463; // @[Lookup.scala 11:37]
  wire [3:0] _T_464; // @[Lookup.scala 11:37]
  wire [3:0] _T_465; // @[Lookup.scala 11:37]
  wire [3:0] _T_466; // @[Lookup.scala 11:37]
  wire [3:0] _T_467; // @[Lookup.scala 11:37]
  wire [3:0] _T_468; // @[Lookup.scala 11:37]
  wire [3:0] ctrlSignals_4; // @[Lookup.scala 11:37]
  wire [2:0] _T_508; // @[Lookup.scala 11:37]
  wire [2:0] _T_509; // @[Lookup.scala 11:37]
  wire [2:0] _T_510; // @[Lookup.scala 11:37]
  wire [2:0] _T_511; // @[Lookup.scala 11:37]
  wire [2:0] _T_512; // @[Lookup.scala 11:37]
  wire [2:0] _T_513; // @[Lookup.scala 11:37]
  wire [2:0] _T_514; // @[Lookup.scala 11:37]
  wire [2:0] _T_515; // @[Lookup.scala 11:37]
  wire [2:0] _T_516; // @[Lookup.scala 11:37]
  wire [2:0] ctrlSignals_5; // @[Lookup.scala 11:37]
  wire  _T_519; // @[Lookup.scala 11:37]
  wire  _T_520; // @[Lookup.scala 11:37]
  wire  _T_521; // @[Lookup.scala 11:37]
  wire  _T_522; // @[Lookup.scala 11:37]
  wire  _T_523; // @[Lookup.scala 11:37]
  wire  _T_524; // @[Lookup.scala 11:37]
  wire  _T_525; // @[Lookup.scala 11:37]
  wire  _T_526; // @[Lookup.scala 11:37]
  wire  _T_527; // @[Lookup.scala 11:37]
  wire  _T_528; // @[Lookup.scala 11:37]
  wire  _T_529; // @[Lookup.scala 11:37]
  wire  _T_530; // @[Lookup.scala 11:37]
  wire  _T_531; // @[Lookup.scala 11:37]
  wire  _T_532; // @[Lookup.scala 11:37]
  wire  _T_533; // @[Lookup.scala 11:37]
  wire  _T_534; // @[Lookup.scala 11:37]
  wire  _T_535; // @[Lookup.scala 11:37]
  wire  _T_536; // @[Lookup.scala 11:37]
  wire  _T_537; // @[Lookup.scala 11:37]
  wire  _T_538; // @[Lookup.scala 11:37]
  wire  _T_539; // @[Lookup.scala 11:37]
  wire  _T_540; // @[Lookup.scala 11:37]
  wire  _T_541; // @[Lookup.scala 11:37]
  wire  _T_542; // @[Lookup.scala 11:37]
  wire  _T_543; // @[Lookup.scala 11:37]
  wire  _T_544; // @[Lookup.scala 11:37]
  wire  _T_545; // @[Lookup.scala 11:37]
  wire  _T_546; // @[Lookup.scala 11:37]
  wire  _T_547; // @[Lookup.scala 11:37]
  wire  _T_548; // @[Lookup.scala 11:37]
  wire  _T_549; // @[Lookup.scala 11:37]
  wire  _T_550; // @[Lookup.scala 11:37]
  wire  _T_551; // @[Lookup.scala 11:37]
  wire  _T_552; // @[Lookup.scala 11:37]
  wire  _T_553; // @[Lookup.scala 11:37]
  wire  _T_554; // @[Lookup.scala 11:37]
  wire  _T_555; // @[Lookup.scala 11:37]
  wire  _T_556; // @[Lookup.scala 11:37]
  wire  _T_557; // @[Lookup.scala 11:37]
  wire  _T_558; // @[Lookup.scala 11:37]
  wire  _T_559; // @[Lookup.scala 11:37]
  wire  _T_560; // @[Lookup.scala 11:37]
  wire  _T_561; // @[Lookup.scala 11:37]
  wire  _T_562; // @[Lookup.scala 11:37]
  wire  _T_563; // @[Lookup.scala 11:37]
  wire  _T_564; // @[Lookup.scala 11:37]
  wire  ctrlSignals_6; // @[Lookup.scala 11:37]
  wire [1:0] _T_596; // @[Lookup.scala 11:37]
  wire [1:0] _T_597; // @[Lookup.scala 11:37]
  wire [1:0] _T_598; // @[Lookup.scala 11:37]
  wire [1:0] _T_599; // @[Lookup.scala 11:37]
  wire [1:0] _T_600; // @[Lookup.scala 11:37]
  wire [1:0] _T_601; // @[Lookup.scala 11:37]
  wire [1:0] _T_602; // @[Lookup.scala 11:37]
  wire [1:0] _T_603; // @[Lookup.scala 11:37]
  wire [1:0] _T_604; // @[Lookup.scala 11:37]
  wire [1:0] _T_605; // @[Lookup.scala 11:37]
  wire [1:0] _T_606; // @[Lookup.scala 11:37]
  wire [1:0] _T_607; // @[Lookup.scala 11:37]
  wire [1:0] _T_608; // @[Lookup.scala 11:37]
  wire [1:0] _T_609; // @[Lookup.scala 11:37]
  wire [1:0] _T_610; // @[Lookup.scala 11:37]
  wire [1:0] _T_611; // @[Lookup.scala 11:37]
  wire [1:0] _T_612; // @[Lookup.scala 11:37]
  wire [1:0] ctrlSignals_7; // @[Lookup.scala 11:37]
  wire [2:0] _T_647; // @[Lookup.scala 11:37]
  wire [2:0] _T_648; // @[Lookup.scala 11:37]
  wire [2:0] _T_649; // @[Lookup.scala 11:37]
  wire [2:0] _T_650; // @[Lookup.scala 11:37]
  wire [2:0] _T_651; // @[Lookup.scala 11:37]
  wire [2:0] _T_652; // @[Lookup.scala 11:37]
  wire [2:0] _T_653; // @[Lookup.scala 11:37]
  wire [2:0] _T_654; // @[Lookup.scala 11:37]
  wire [2:0] _T_655; // @[Lookup.scala 11:37]
  wire [2:0] _T_656; // @[Lookup.scala 11:37]
  wire [2:0] _T_657; // @[Lookup.scala 11:37]
  wire [2:0] _T_658; // @[Lookup.scala 11:37]
  wire [2:0] _T_659; // @[Lookup.scala 11:37]
  wire [2:0] _T_660; // @[Lookup.scala 11:37]
  wire [2:0] ctrlSignals_8; // @[Lookup.scala 11:37]
  wire [1:0] _T_663; // @[Lookup.scala 11:37]
  wire [1:0] _T_664; // @[Lookup.scala 11:37]
  wire [1:0] _T_665; // @[Lookup.scala 11:37]
  wire [1:0] _T_666; // @[Lookup.scala 11:37]
  wire [1:0] _T_667; // @[Lookup.scala 11:37]
  wire [1:0] _T_668; // @[Lookup.scala 11:37]
  wire [1:0] _T_669; // @[Lookup.scala 11:37]
  wire [1:0] _T_670; // @[Lookup.scala 11:37]
  wire [1:0] _T_671; // @[Lookup.scala 11:37]
  wire [1:0] _T_672; // @[Lookup.scala 11:37]
  wire [1:0] _T_673; // @[Lookup.scala 11:37]
  wire [1:0] _T_674; // @[Lookup.scala 11:37]
  wire [1:0] _T_675; // @[Lookup.scala 11:37]
  wire [1:0] _T_676; // @[Lookup.scala 11:37]
  wire [1:0] _T_677; // @[Lookup.scala 11:37]
  wire [1:0] _T_678; // @[Lookup.scala 11:37]
  wire [1:0] _T_679; // @[Lookup.scala 11:37]
  wire [1:0] _T_680; // @[Lookup.scala 11:37]
  wire [1:0] _T_681; // @[Lookup.scala 11:37]
  wire [1:0] _T_682; // @[Lookup.scala 11:37]
  wire [1:0] _T_683; // @[Lookup.scala 11:37]
  wire [1:0] _T_684; // @[Lookup.scala 11:37]
  wire [1:0] _T_685; // @[Lookup.scala 11:37]
  wire [1:0] _T_686; // @[Lookup.scala 11:37]
  wire [1:0] _T_687; // @[Lookup.scala 11:37]
  wire [1:0] _T_688; // @[Lookup.scala 11:37]
  wire [1:0] _T_689; // @[Lookup.scala 11:37]
  wire [1:0] _T_690; // @[Lookup.scala 11:37]
  wire [1:0] _T_691; // @[Lookup.scala 11:37]
  wire [1:0] _T_692; // @[Lookup.scala 11:37]
  wire [1:0] _T_693; // @[Lookup.scala 11:37]
  wire [1:0] _T_694; // @[Lookup.scala 11:37]
  wire [1:0] _T_695; // @[Lookup.scala 11:37]
  wire [1:0] _T_696; // @[Lookup.scala 11:37]
  wire [1:0] _T_697; // @[Lookup.scala 11:37]
  wire [1:0] _T_698; // @[Lookup.scala 11:37]
  wire [1:0] _T_699; // @[Lookup.scala 11:37]
  wire [1:0] _T_700; // @[Lookup.scala 11:37]
  wire [1:0] _T_701; // @[Lookup.scala 11:37]
  wire [1:0] _T_702; // @[Lookup.scala 11:37]
  wire [1:0] _T_703; // @[Lookup.scala 11:37]
  wire [1:0] _T_704; // @[Lookup.scala 11:37]
  wire [1:0] _T_705; // @[Lookup.scala 11:37]
  wire [1:0] _T_706; // @[Lookup.scala 11:37]
  wire [1:0] _T_707; // @[Lookup.scala 11:37]
  wire [1:0] _T_708; // @[Lookup.scala 11:37]
  wire [1:0] ctrlSignals_9; // @[Lookup.scala 11:37]
  wire  _T_714; // @[Lookup.scala 11:37]
  wire  _T_715; // @[Lookup.scala 11:37]
  wire  _T_716; // @[Lookup.scala 11:37]
  wire  _T_717; // @[Lookup.scala 11:37]
  wire  _T_718; // @[Lookup.scala 11:37]
  wire  _T_719; // @[Lookup.scala 11:37]
  wire  _T_720; // @[Lookup.scala 11:37]
  wire  _T_721; // @[Lookup.scala 11:37]
  wire  _T_722; // @[Lookup.scala 11:37]
  wire  _T_723; // @[Lookup.scala 11:37]
  wire  _T_724; // @[Lookup.scala 11:37]
  wire  _T_725; // @[Lookup.scala 11:37]
  wire  _T_726; // @[Lookup.scala 11:37]
  wire  _T_727; // @[Lookup.scala 11:37]
  wire  _T_728; // @[Lookup.scala 11:37]
  wire  _T_729; // @[Lookup.scala 11:37]
  wire  _T_730; // @[Lookup.scala 11:37]
  wire  _T_731; // @[Lookup.scala 11:37]
  wire  _T_732; // @[Lookup.scala 11:37]
  wire  _T_733; // @[Lookup.scala 11:37]
  wire  _T_734; // @[Lookup.scala 11:37]
  wire  _T_735; // @[Lookup.scala 11:37]
  wire  _T_736; // @[Lookup.scala 11:37]
  wire  _T_737; // @[Lookup.scala 11:37]
  wire  _T_738; // @[Lookup.scala 11:37]
  wire  _T_739; // @[Lookup.scala 11:37]
  wire  _T_740; // @[Lookup.scala 11:37]
  wire  _T_741; // @[Lookup.scala 11:37]
  wire  _T_742; // @[Lookup.scala 11:37]
  wire  _T_743; // @[Lookup.scala 11:37]
  wire  _T_744; // @[Lookup.scala 11:37]
  wire  _T_745; // @[Lookup.scala 11:37]
  wire  _T_746; // @[Lookup.scala 11:37]
  wire  _T_747; // @[Lookup.scala 11:37]
  wire  _T_748; // @[Lookup.scala 11:37]
  wire  _T_749; // @[Lookup.scala 11:37]
  wire  _T_750; // @[Lookup.scala 11:37]
  wire  _T_751; // @[Lookup.scala 11:37]
  wire  _T_752; // @[Lookup.scala 11:37]
  wire  _T_753; // @[Lookup.scala 11:37]
  wire  _T_754; // @[Lookup.scala 11:37]
  wire  _T_755; // @[Lookup.scala 11:37]
  wire  _T_756; // @[Lookup.scala 11:37]
  wire  ctrlSignals_10; // @[Lookup.scala 11:37]
  wire [2:0] _T_758; // @[Lookup.scala 11:37]
  wire [2:0] _T_759; // @[Lookup.scala 11:37]
  wire [2:0] _T_760; // @[Lookup.scala 11:37]
  wire [2:0] _T_761; // @[Lookup.scala 11:37]
  wire [2:0] _T_762; // @[Lookup.scala 11:37]
  wire [2:0] _T_763; // @[Lookup.scala 11:37]
  wire [2:0] _T_764; // @[Lookup.scala 11:37]
  wire [2:0] _T_765; // @[Lookup.scala 11:37]
  wire [2:0] _T_766; // @[Lookup.scala 11:37]
  wire [2:0] _T_767; // @[Lookup.scala 11:37]
  wire [2:0] _T_768; // @[Lookup.scala 11:37]
  wire [2:0] _T_769; // @[Lookup.scala 11:37]
  wire [2:0] _T_770; // @[Lookup.scala 11:37]
  wire [2:0] _T_771; // @[Lookup.scala 11:37]
  wire [2:0] _T_772; // @[Lookup.scala 11:37]
  wire [2:0] _T_773; // @[Lookup.scala 11:37]
  wire [2:0] _T_774; // @[Lookup.scala 11:37]
  wire [2:0] _T_775; // @[Lookup.scala 11:37]
  wire [2:0] _T_776; // @[Lookup.scala 11:37]
  wire [2:0] _T_777; // @[Lookup.scala 11:37]
  wire [2:0] _T_778; // @[Lookup.scala 11:37]
  wire [2:0] _T_779; // @[Lookup.scala 11:37]
  wire [2:0] _T_780; // @[Lookup.scala 11:37]
  wire [2:0] _T_781; // @[Lookup.scala 11:37]
  wire [2:0] _T_782; // @[Lookup.scala 11:37]
  wire [2:0] _T_783; // @[Lookup.scala 11:37]
  wire [2:0] _T_784; // @[Lookup.scala 11:37]
  wire [2:0] _T_785; // @[Lookup.scala 11:37]
  wire [2:0] _T_786; // @[Lookup.scala 11:37]
  wire [2:0] _T_787; // @[Lookup.scala 11:37]
  wire [2:0] _T_788; // @[Lookup.scala 11:37]
  wire [2:0] _T_789; // @[Lookup.scala 11:37]
  wire [2:0] _T_790; // @[Lookup.scala 11:37]
  wire [2:0] _T_791; // @[Lookup.scala 11:37]
  wire [2:0] _T_792; // @[Lookup.scala 11:37]
  wire [2:0] _T_793; // @[Lookup.scala 11:37]
  wire [2:0] _T_794; // @[Lookup.scala 11:37]
  wire [2:0] _T_795; // @[Lookup.scala 11:37]
  wire [2:0] _T_796; // @[Lookup.scala 11:37]
  wire [2:0] _T_797; // @[Lookup.scala 11:37]
  wire [2:0] _T_798; // @[Lookup.scala 11:37]
  wire [2:0] _T_799; // @[Lookup.scala 11:37]
  wire [2:0] _T_800; // @[Lookup.scala 11:37]
  wire [2:0] _T_801; // @[Lookup.scala 11:37]
  wire [2:0] _T_802; // @[Lookup.scala 11:37]
  wire [2:0] _T_803; // @[Lookup.scala 11:37]
  wire [2:0] _T_804; // @[Lookup.scala 11:37]
  wire [2:0] ctrlSignals_11; // @[Lookup.scala 11:37]
  wire  _T_805; // @[Lookup.scala 11:37]
  wire  _T_806; // @[Lookup.scala 11:37]
  wire  _T_807; // @[Lookup.scala 11:37]
  wire  _T_808; // @[Lookup.scala 11:37]
  wire  _T_809; // @[Lookup.scala 11:37]
  wire  _T_810; // @[Lookup.scala 11:37]
  wire  _T_811; // @[Lookup.scala 11:37]
  wire  _T_812; // @[Lookup.scala 11:37]
  wire  _T_813; // @[Lookup.scala 11:37]
  wire  _T_814; // @[Lookup.scala 11:37]
  wire  _T_815; // @[Lookup.scala 11:37]
  wire  _T_816; // @[Lookup.scala 11:37]
  wire  _T_817; // @[Lookup.scala 11:37]
  wire  _T_818; // @[Lookup.scala 11:37]
  wire  _T_819; // @[Lookup.scala 11:37]
  wire  _T_820; // @[Lookup.scala 11:37]
  wire  _T_821; // @[Lookup.scala 11:37]
  wire  _T_822; // @[Lookup.scala 11:37]
  wire  _T_823; // @[Lookup.scala 11:37]
  wire  _T_824; // @[Lookup.scala 11:37]
  wire  _T_825; // @[Lookup.scala 11:37]
  wire  _T_826; // @[Lookup.scala 11:37]
  wire  _T_827; // @[Lookup.scala 11:37]
  wire  _T_828; // @[Lookup.scala 11:37]
  wire  _T_829; // @[Lookup.scala 11:37]
  wire  _T_830; // @[Lookup.scala 11:37]
  wire  _T_831; // @[Lookup.scala 11:37]
  wire  _T_832; // @[Lookup.scala 11:37]
  wire  _T_833; // @[Lookup.scala 11:37]
  wire  _T_834; // @[Lookup.scala 11:37]
  wire  _T_835; // @[Lookup.scala 11:37]
  wire  _T_836; // @[Lookup.scala 11:37]
  wire  _T_837; // @[Lookup.scala 11:37]
  wire  _T_838; // @[Lookup.scala 11:37]
  wire  _T_839; // @[Lookup.scala 11:37]
  wire  _T_840; // @[Lookup.scala 11:37]
  wire  _T_841; // @[Lookup.scala 11:37]
  wire  _T_842; // @[Lookup.scala 11:37]
  wire  _T_843; // @[Lookup.scala 11:37]
  wire  _T_844; // @[Lookup.scala 11:37]
  wire  _T_845; // @[Lookup.scala 11:37]
  wire  _T_846; // @[Lookup.scala 11:37]
  wire  _T_847; // @[Lookup.scala 11:37]
  wire  _T_848; // @[Lookup.scala 11:37]
  wire  _T_849; // @[Lookup.scala 11:37]
  wire  _T_850; // @[Lookup.scala 11:37]
  wire  _T_851; // @[Lookup.scala 11:37]
  wire  _T_852; // @[Lookup.scala 11:37]
  wire  ctrlSignals_12; // @[Lookup.scala 11:37]
  assign _T_35 = io_inst & 32'h7f; // @[Lookup.scala 9:38]
  assign _T_36 = 32'h37 == _T_35; // @[Lookup.scala 9:38]
  assign _T_40 = 32'h17 == _T_35; // @[Lookup.scala 9:38]
  assign _T_44 = 32'h6f == _T_35; // @[Lookup.scala 9:38]
  assign _T_47 = io_inst & 32'h707f; // @[Lookup.scala 9:38]
  assign _T_48 = 32'h67 == _T_47; // @[Lookup.scala 9:38]
  assign _T_52 = 32'h63 == _T_47; // @[Lookup.scala 9:38]
  assign _T_56 = 32'h1063 == _T_47; // @[Lookup.scala 9:38]
  assign _T_60 = 32'h4063 == _T_47; // @[Lookup.scala 9:38]
  assign _T_64 = 32'h5063 == _T_47; // @[Lookup.scala 9:38]
  assign _T_68 = 32'h6063 == _T_47; // @[Lookup.scala 9:38]
  assign _T_72 = 32'h7063 == _T_47; // @[Lookup.scala 9:38]
  assign _T_76 = 32'h3 == _T_47; // @[Lookup.scala 9:38]
  assign _T_80 = 32'h1003 == _T_47; // @[Lookup.scala 9:38]
  assign _T_84 = 32'h2003 == _T_47; // @[Lookup.scala 9:38]
  assign _T_88 = 32'h4003 == _T_47; // @[Lookup.scala 9:38]
  assign _T_92 = 32'h5003 == _T_47; // @[Lookup.scala 9:38]
  assign _T_96 = 32'h23 == _T_47; // @[Lookup.scala 9:38]
  assign _T_100 = 32'h1023 == _T_47; // @[Lookup.scala 9:38]
  assign _T_104 = 32'h2023 == _T_47; // @[Lookup.scala 9:38]
  assign _T_108 = 32'h13 == _T_47; // @[Lookup.scala 9:38]
  assign _T_112 = 32'h2013 == _T_47; // @[Lookup.scala 9:38]
  assign _T_116 = 32'h3013 == _T_47; // @[Lookup.scala 9:38]
  assign _T_120 = 32'h4013 == _T_47; // @[Lookup.scala 9:38]
  assign _T_124 = 32'h6013 == _T_47; // @[Lookup.scala 9:38]
  assign _T_128 = 32'h7013 == _T_47; // @[Lookup.scala 9:38]
  assign _T_131 = io_inst & 32'hfe00707f; // @[Lookup.scala 9:38]
  assign _T_132 = 32'h1013 == _T_131; // @[Lookup.scala 9:38]
  assign _T_136 = 32'h5013 == _T_131; // @[Lookup.scala 9:38]
  assign _T_140 = 32'h40005013 == _T_131; // @[Lookup.scala 9:38]
  assign _T_144 = 32'h33 == _T_131; // @[Lookup.scala 9:38]
  assign _T_148 = 32'h40000033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_152 = 32'h1033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_156 = 32'h2033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_160 = 32'h3033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_164 = 32'h4033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_168 = 32'h5033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_172 = 32'h40005033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_176 = 32'h6033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_180 = 32'h7033 == _T_131; // @[Lookup.scala 9:38]
  assign _T_183 = io_inst & 32'hf00fffff; // @[Lookup.scala 9:38]
  assign _T_184 = 32'hf == _T_183; // @[Lookup.scala 9:38]
  assign _T_188 = 32'h100f == io_inst; // @[Lookup.scala 9:38]
  assign _T_192 = 32'h1073 == _T_47; // @[Lookup.scala 9:38]
  assign _T_196 = 32'h2073 == _T_47; // @[Lookup.scala 9:38]
  assign _T_200 = 32'h3073 == _T_47; // @[Lookup.scala 9:38]
  assign _T_204 = 32'h5073 == _T_47; // @[Lookup.scala 9:38]
  assign _T_208 = 32'h6073 == _T_47; // @[Lookup.scala 9:38]
  assign _T_212 = 32'h7073 == _T_47; // @[Lookup.scala 9:38]
  assign _T_216 = 32'h73 == io_inst; // @[Lookup.scala 9:38]
  assign _T_220 = 32'h100073 == io_inst; // @[Lookup.scala 9:38]
  assign _T_224 = 32'h10000073 == io_inst; // @[Lookup.scala 9:38]
  assign _T_228 = 32'h10200073 == io_inst; // @[Lookup.scala 9:38]
  assign _T_230 = _T_224 ? 2'h3 : 2'h0; // @[Lookup.scala 11:37]
  assign _T_231 = _T_220 ? 2'h0 : _T_230; // @[Lookup.scala 11:37]
  assign _T_232 = _T_216 ? 2'h0 : _T_231; // @[Lookup.scala 11:37]
  assign _T_233 = _T_212 ? 2'h2 : _T_232; // @[Lookup.scala 11:37]
  assign _T_234 = _T_208 ? 2'h2 : _T_233; // @[Lookup.scala 11:37]
  assign _T_235 = _T_204 ? 2'h2 : _T_234; // @[Lookup.scala 11:37]
  assign _T_236 = _T_200 ? 2'h2 : _T_235; // @[Lookup.scala 11:37]
  assign _T_237 = _T_196 ? 2'h2 : _T_236; // @[Lookup.scala 11:37]
  assign _T_238 = _T_192 ? 2'h2 : _T_237; // @[Lookup.scala 11:37]
  assign _T_239 = _T_188 ? 2'h2 : _T_238; // @[Lookup.scala 11:37]
  assign _T_240 = _T_184 ? 2'h0 : _T_239; // @[Lookup.scala 11:37]
  assign _T_241 = _T_180 ? 2'h0 : _T_240; // @[Lookup.scala 11:37]
  assign _T_242 = _T_176 ? 2'h0 : _T_241; // @[Lookup.scala 11:37]
  assign _T_243 = _T_172 ? 2'h0 : _T_242; // @[Lookup.scala 11:37]
  assign _T_244 = _T_168 ? 2'h0 : _T_243; // @[Lookup.scala 11:37]
  assign _T_245 = _T_164 ? 2'h0 : _T_244; // @[Lookup.scala 11:37]
  assign _T_246 = _T_160 ? 2'h0 : _T_245; // @[Lookup.scala 11:37]
  assign _T_247 = _T_156 ? 2'h0 : _T_246; // @[Lookup.scala 11:37]
  assign _T_248 = _T_152 ? 2'h0 : _T_247; // @[Lookup.scala 11:37]
  assign _T_249 = _T_148 ? 2'h0 : _T_248; // @[Lookup.scala 11:37]
  assign _T_250 = _T_144 ? 2'h0 : _T_249; // @[Lookup.scala 11:37]
  assign _T_251 = _T_140 ? 2'h0 : _T_250; // @[Lookup.scala 11:37]
  assign _T_252 = _T_136 ? 2'h0 : _T_251; // @[Lookup.scala 11:37]
  assign _T_253 = _T_132 ? 2'h0 : _T_252; // @[Lookup.scala 11:37]
  assign _T_254 = _T_128 ? 2'h0 : _T_253; // @[Lookup.scala 11:37]
  assign _T_255 = _T_124 ? 2'h0 : _T_254; // @[Lookup.scala 11:37]
  assign _T_256 = _T_120 ? 2'h0 : _T_255; // @[Lookup.scala 11:37]
  assign _T_257 = _T_116 ? 2'h0 : _T_256; // @[Lookup.scala 11:37]
  assign _T_258 = _T_112 ? 2'h0 : _T_257; // @[Lookup.scala 11:37]
  assign _T_259 = _T_108 ? 2'h0 : _T_258; // @[Lookup.scala 11:37]
  assign _T_260 = _T_104 ? 2'h0 : _T_259; // @[Lookup.scala 11:37]
  assign _T_261 = _T_100 ? 2'h0 : _T_260; // @[Lookup.scala 11:37]
  assign _T_262 = _T_96 ? 2'h0 : _T_261; // @[Lookup.scala 11:37]
  assign _T_263 = _T_92 ? 2'h2 : _T_262; // @[Lookup.scala 11:37]
  assign _T_264 = _T_88 ? 2'h2 : _T_263; // @[Lookup.scala 11:37]
  assign _T_265 = _T_84 ? 2'h2 : _T_264; // @[Lookup.scala 11:37]
  assign _T_266 = _T_80 ? 2'h2 : _T_265; // @[Lookup.scala 11:37]
  assign _T_267 = _T_76 ? 2'h2 : _T_266; // @[Lookup.scala 11:37]
  assign _T_268 = _T_72 ? 2'h0 : _T_267; // @[Lookup.scala 11:37]
  assign _T_269 = _T_68 ? 2'h0 : _T_268; // @[Lookup.scala 11:37]
  assign _T_270 = _T_64 ? 2'h0 : _T_269; // @[Lookup.scala 11:37]
  assign _T_271 = _T_60 ? 2'h0 : _T_270; // @[Lookup.scala 11:37]
  assign _T_272 = _T_56 ? 2'h0 : _T_271; // @[Lookup.scala 11:37]
  assign _T_273 = _T_52 ? 2'h0 : _T_272; // @[Lookup.scala 11:37]
  assign _T_274 = _T_48 ? 2'h1 : _T_273; // @[Lookup.scala 11:37]
  assign _T_275 = _T_44 ? 2'h1 : _T_274; // @[Lookup.scala 11:37]
  assign _T_276 = _T_40 ? 2'h0 : _T_275; // @[Lookup.scala 11:37]
  assign ctrlSignals_0 = _T_36 ? 2'h0 : _T_276; // @[Lookup.scala 11:37]
  assign _T_285 = _T_196 ? 1'h1 : _T_200; // @[Lookup.scala 11:37]
  assign _T_286 = _T_192 ? 1'h1 : _T_285; // @[Lookup.scala 11:37]
  assign _T_287 = _T_188 ? 1'h0 : _T_286; // @[Lookup.scala 11:37]
  assign _T_288 = _T_184 ? 1'h0 : _T_287; // @[Lookup.scala 11:37]
  assign _T_289 = _T_180 ? 1'h1 : _T_288; // @[Lookup.scala 11:37]
  assign _T_290 = _T_176 ? 1'h1 : _T_289; // @[Lookup.scala 11:37]
  assign _T_291 = _T_172 ? 1'h1 : _T_290; // @[Lookup.scala 11:37]
  assign _T_292 = _T_168 ? 1'h1 : _T_291; // @[Lookup.scala 11:37]
  assign _T_293 = _T_164 ? 1'h1 : _T_292; // @[Lookup.scala 11:37]
  assign _T_294 = _T_160 ? 1'h1 : _T_293; // @[Lookup.scala 11:37]
  assign _T_295 = _T_156 ? 1'h1 : _T_294; // @[Lookup.scala 11:37]
  assign _T_296 = _T_152 ? 1'h1 : _T_295; // @[Lookup.scala 11:37]
  assign _T_297 = _T_148 ? 1'h1 : _T_296; // @[Lookup.scala 11:37]
  assign _T_298 = _T_144 ? 1'h1 : _T_297; // @[Lookup.scala 11:37]
  assign _T_299 = _T_140 ? 1'h1 : _T_298; // @[Lookup.scala 11:37]
  assign _T_300 = _T_136 ? 1'h1 : _T_299; // @[Lookup.scala 11:37]
  assign _T_301 = _T_132 ? 1'h1 : _T_300; // @[Lookup.scala 11:37]
  assign _T_302 = _T_128 ? 1'h1 : _T_301; // @[Lookup.scala 11:37]
  assign _T_303 = _T_124 ? 1'h1 : _T_302; // @[Lookup.scala 11:37]
  assign _T_304 = _T_120 ? 1'h1 : _T_303; // @[Lookup.scala 11:37]
  assign _T_305 = _T_116 ? 1'h1 : _T_304; // @[Lookup.scala 11:37]
  assign _T_306 = _T_112 ? 1'h1 : _T_305; // @[Lookup.scala 11:37]
  assign _T_307 = _T_108 ? 1'h1 : _T_306; // @[Lookup.scala 11:37]
  assign _T_308 = _T_104 ? 1'h1 : _T_307; // @[Lookup.scala 11:37]
  assign _T_309 = _T_100 ? 1'h1 : _T_308; // @[Lookup.scala 11:37]
  assign _T_310 = _T_96 ? 1'h1 : _T_309; // @[Lookup.scala 11:37]
  assign _T_311 = _T_92 ? 1'h1 : _T_310; // @[Lookup.scala 11:37]
  assign _T_312 = _T_88 ? 1'h1 : _T_311; // @[Lookup.scala 11:37]
  assign _T_313 = _T_84 ? 1'h1 : _T_312; // @[Lookup.scala 11:37]
  assign _T_314 = _T_80 ? 1'h1 : _T_313; // @[Lookup.scala 11:37]
  assign _T_315 = _T_76 ? 1'h1 : _T_314; // @[Lookup.scala 11:37]
  assign _T_316 = _T_72 ? 1'h0 : _T_315; // @[Lookup.scala 11:37]
  assign _T_317 = _T_68 ? 1'h0 : _T_316; // @[Lookup.scala 11:37]
  assign _T_318 = _T_64 ? 1'h0 : _T_317; // @[Lookup.scala 11:37]
  assign _T_319 = _T_60 ? 1'h0 : _T_318; // @[Lookup.scala 11:37]
  assign _T_320 = _T_56 ? 1'h0 : _T_319; // @[Lookup.scala 11:37]
  assign _T_321 = _T_52 ? 1'h0 : _T_320; // @[Lookup.scala 11:37]
  assign _T_322 = _T_48 ? 1'h1 : _T_321; // @[Lookup.scala 11:37]
  assign _T_323 = _T_44 ? 1'h0 : _T_322; // @[Lookup.scala 11:37]
  assign _T_324 = _T_40 ? 1'h0 : _T_323; // @[Lookup.scala 11:37]
  assign ctrlSignals_1 = _T_36 ? 1'h0 : _T_324; // @[Lookup.scala 11:37]
  assign _T_338 = _T_176 ? 1'h1 : _T_180; // @[Lookup.scala 11:37]
  assign _T_339 = _T_172 ? 1'h1 : _T_338; // @[Lookup.scala 11:37]
  assign _T_340 = _T_168 ? 1'h1 : _T_339; // @[Lookup.scala 11:37]
  assign _T_341 = _T_164 ? 1'h1 : _T_340; // @[Lookup.scala 11:37]
  assign _T_342 = _T_160 ? 1'h1 : _T_341; // @[Lookup.scala 11:37]
  assign _T_343 = _T_156 ? 1'h1 : _T_342; // @[Lookup.scala 11:37]
  assign _T_344 = _T_152 ? 1'h1 : _T_343; // @[Lookup.scala 11:37]
  assign _T_345 = _T_148 ? 1'h1 : _T_344; // @[Lookup.scala 11:37]
  assign _T_346 = _T_144 ? 1'h1 : _T_345; // @[Lookup.scala 11:37]
  assign _T_347 = _T_140 ? 1'h0 : _T_346; // @[Lookup.scala 11:37]
  assign _T_348 = _T_136 ? 1'h0 : _T_347; // @[Lookup.scala 11:37]
  assign _T_349 = _T_132 ? 1'h0 : _T_348; // @[Lookup.scala 11:37]
  assign _T_350 = _T_128 ? 1'h0 : _T_349; // @[Lookup.scala 11:37]
  assign _T_351 = _T_124 ? 1'h0 : _T_350; // @[Lookup.scala 11:37]
  assign _T_352 = _T_120 ? 1'h0 : _T_351; // @[Lookup.scala 11:37]
  assign _T_353 = _T_116 ? 1'h0 : _T_352; // @[Lookup.scala 11:37]
  assign _T_354 = _T_112 ? 1'h0 : _T_353; // @[Lookup.scala 11:37]
  assign _T_355 = _T_108 ? 1'h0 : _T_354; // @[Lookup.scala 11:37]
  assign _T_356 = _T_104 ? 1'h0 : _T_355; // @[Lookup.scala 11:37]
  assign _T_357 = _T_100 ? 1'h0 : _T_356; // @[Lookup.scala 11:37]
  assign _T_358 = _T_96 ? 1'h0 : _T_357; // @[Lookup.scala 11:37]
  assign _T_359 = _T_92 ? 1'h0 : _T_358; // @[Lookup.scala 11:37]
  assign _T_360 = _T_88 ? 1'h0 : _T_359; // @[Lookup.scala 11:37]
  assign _T_361 = _T_84 ? 1'h0 : _T_360; // @[Lookup.scala 11:37]
  assign _T_362 = _T_80 ? 1'h0 : _T_361; // @[Lookup.scala 11:37]
  assign _T_363 = _T_76 ? 1'h0 : _T_362; // @[Lookup.scala 11:37]
  assign _T_364 = _T_72 ? 1'h0 : _T_363; // @[Lookup.scala 11:37]
  assign _T_365 = _T_68 ? 1'h0 : _T_364; // @[Lookup.scala 11:37]
  assign _T_366 = _T_64 ? 1'h0 : _T_365; // @[Lookup.scala 11:37]
  assign _T_367 = _T_60 ? 1'h0 : _T_366; // @[Lookup.scala 11:37]
  assign _T_368 = _T_56 ? 1'h0 : _T_367; // @[Lookup.scala 11:37]
  assign _T_369 = _T_52 ? 1'h0 : _T_368; // @[Lookup.scala 11:37]
  assign _T_370 = _T_48 ? 1'h0 : _T_369; // @[Lookup.scala 11:37]
  assign _T_371 = _T_44 ? 1'h0 : _T_370; // @[Lookup.scala 11:37]
  assign _T_372 = _T_40 ? 1'h0 : _T_371; // @[Lookup.scala 11:37]
  assign ctrlSignals_2 = _T_36 ? 1'h0 : _T_372; // @[Lookup.scala 11:37]
  assign _T_377 = _T_212 ? 3'h6 : 3'h0; // @[Lookup.scala 11:37]
  assign _T_378 = _T_208 ? 3'h6 : _T_377; // @[Lookup.scala 11:37]
  assign _T_379 = _T_204 ? 3'h6 : _T_378; // @[Lookup.scala 11:37]
  assign _T_380 = _T_200 ? 3'h0 : _T_379; // @[Lookup.scala 11:37]
  assign _T_381 = _T_196 ? 3'h0 : _T_380; // @[Lookup.scala 11:37]
  assign _T_382 = _T_192 ? 3'h0 : _T_381; // @[Lookup.scala 11:37]
  assign _T_383 = _T_188 ? 3'h0 : _T_382; // @[Lookup.scala 11:37]
  assign _T_384 = _T_184 ? 3'h0 : _T_383; // @[Lookup.scala 11:37]
  assign _T_385 = _T_180 ? 3'h0 : _T_384; // @[Lookup.scala 11:37]
  assign _T_386 = _T_176 ? 3'h0 : _T_385; // @[Lookup.scala 11:37]
  assign _T_387 = _T_172 ? 3'h0 : _T_386; // @[Lookup.scala 11:37]
  assign _T_388 = _T_168 ? 3'h0 : _T_387; // @[Lookup.scala 11:37]
  assign _T_389 = _T_164 ? 3'h0 : _T_388; // @[Lookup.scala 11:37]
  assign _T_390 = _T_160 ? 3'h0 : _T_389; // @[Lookup.scala 11:37]
  assign _T_391 = _T_156 ? 3'h0 : _T_390; // @[Lookup.scala 11:37]
  assign _T_392 = _T_152 ? 3'h0 : _T_391; // @[Lookup.scala 11:37]
  assign _T_393 = _T_148 ? 3'h0 : _T_392; // @[Lookup.scala 11:37]
  assign _T_394 = _T_144 ? 3'h0 : _T_393; // @[Lookup.scala 11:37]
  assign _T_395 = _T_140 ? 3'h1 : _T_394; // @[Lookup.scala 11:37]
  assign _T_396 = _T_136 ? 3'h1 : _T_395; // @[Lookup.scala 11:37]
  assign _T_397 = _T_132 ? 3'h1 : _T_396; // @[Lookup.scala 11:37]
  assign _T_398 = _T_128 ? 3'h1 : _T_397; // @[Lookup.scala 11:37]
  assign _T_399 = _T_124 ? 3'h1 : _T_398; // @[Lookup.scala 11:37]
  assign _T_400 = _T_120 ? 3'h1 : _T_399; // @[Lookup.scala 11:37]
  assign _T_401 = _T_116 ? 3'h1 : _T_400; // @[Lookup.scala 11:37]
  assign _T_402 = _T_112 ? 3'h1 : _T_401; // @[Lookup.scala 11:37]
  assign _T_403 = _T_108 ? 3'h1 : _T_402; // @[Lookup.scala 11:37]
  assign _T_404 = _T_104 ? 3'h2 : _T_403; // @[Lookup.scala 11:37]
  assign _T_405 = _T_100 ? 3'h2 : _T_404; // @[Lookup.scala 11:37]
  assign _T_406 = _T_96 ? 3'h2 : _T_405; // @[Lookup.scala 11:37]
  assign _T_407 = _T_92 ? 3'h1 : _T_406; // @[Lookup.scala 11:37]
  assign _T_408 = _T_88 ? 3'h1 : _T_407; // @[Lookup.scala 11:37]
  assign _T_409 = _T_84 ? 3'h1 : _T_408; // @[Lookup.scala 11:37]
  assign _T_410 = _T_80 ? 3'h1 : _T_409; // @[Lookup.scala 11:37]
  assign _T_411 = _T_76 ? 3'h1 : _T_410; // @[Lookup.scala 11:37]
  assign _T_412 = _T_72 ? 3'h5 : _T_411; // @[Lookup.scala 11:37]
  assign _T_413 = _T_68 ? 3'h5 : _T_412; // @[Lookup.scala 11:37]
  assign _T_414 = _T_64 ? 3'h5 : _T_413; // @[Lookup.scala 11:37]
  assign _T_415 = _T_60 ? 3'h5 : _T_414; // @[Lookup.scala 11:37]
  assign _T_416 = _T_56 ? 3'h5 : _T_415; // @[Lookup.scala 11:37]
  assign _T_417 = _T_52 ? 3'h5 : _T_416; // @[Lookup.scala 11:37]
  assign _T_418 = _T_48 ? 3'h1 : _T_417; // @[Lookup.scala 11:37]
  assign _T_419 = _T_44 ? 3'h4 : _T_418; // @[Lookup.scala 11:37]
  assign _T_420 = _T_40 ? 3'h3 : _T_419; // @[Lookup.scala 11:37]
  assign ctrlSignals_3 = _T_36 ? 3'h3 : _T_420; // @[Lookup.scala 11:37]
  assign _T_428 = _T_200 ? 4'ha : 4'hf; // @[Lookup.scala 11:37]
  assign _T_429 = _T_196 ? 4'ha : _T_428; // @[Lookup.scala 11:37]
  assign _T_430 = _T_192 ? 4'ha : _T_429; // @[Lookup.scala 11:37]
  assign _T_431 = _T_188 ? 4'hf : _T_430; // @[Lookup.scala 11:37]
  assign _T_432 = _T_184 ? 4'hf : _T_431; // @[Lookup.scala 11:37]
  assign _T_433 = _T_180 ? 4'h2 : _T_432; // @[Lookup.scala 11:37]
  assign _T_434 = _T_176 ? 4'h3 : _T_433; // @[Lookup.scala 11:37]
  assign _T_435 = _T_172 ? 4'h9 : _T_434; // @[Lookup.scala 11:37]
  assign _T_436 = _T_168 ? 4'h8 : _T_435; // @[Lookup.scala 11:37]
  assign _T_437 = _T_164 ? 4'h4 : _T_436; // @[Lookup.scala 11:37]
  assign _T_438 = _T_160 ? 4'h7 : _T_437; // @[Lookup.scala 11:37]
  assign _T_439 = _T_156 ? 4'h5 : _T_438; // @[Lookup.scala 11:37]
  assign _T_440 = _T_152 ? 4'h6 : _T_439; // @[Lookup.scala 11:37]
  assign _T_441 = _T_148 ? 4'h1 : _T_440; // @[Lookup.scala 11:37]
  assign _T_442 = _T_144 ? 4'h0 : _T_441; // @[Lookup.scala 11:37]
  assign _T_443 = _T_140 ? 4'h9 : _T_442; // @[Lookup.scala 11:37]
  assign _T_444 = _T_136 ? 4'h8 : _T_443; // @[Lookup.scala 11:37]
  assign _T_445 = _T_132 ? 4'h6 : _T_444; // @[Lookup.scala 11:37]
  assign _T_446 = _T_128 ? 4'h2 : _T_445; // @[Lookup.scala 11:37]
  assign _T_447 = _T_124 ? 4'h3 : _T_446; // @[Lookup.scala 11:37]
  assign _T_448 = _T_120 ? 4'h4 : _T_447; // @[Lookup.scala 11:37]
  assign _T_449 = _T_116 ? 4'h7 : _T_448; // @[Lookup.scala 11:37]
  assign _T_450 = _T_112 ? 4'h5 : _T_449; // @[Lookup.scala 11:37]
  assign _T_451 = _T_108 ? 4'h0 : _T_450; // @[Lookup.scala 11:37]
  assign _T_452 = _T_104 ? 4'h0 : _T_451; // @[Lookup.scala 11:37]
  assign _T_453 = _T_100 ? 4'h0 : _T_452; // @[Lookup.scala 11:37]
  assign _T_454 = _T_96 ? 4'h0 : _T_453; // @[Lookup.scala 11:37]
  assign _T_455 = _T_92 ? 4'h0 : _T_454; // @[Lookup.scala 11:37]
  assign _T_456 = _T_88 ? 4'h0 : _T_455; // @[Lookup.scala 11:37]
  assign _T_457 = _T_84 ? 4'h0 : _T_456; // @[Lookup.scala 11:37]
  assign _T_458 = _T_80 ? 4'h0 : _T_457; // @[Lookup.scala 11:37]
  assign _T_459 = _T_76 ? 4'h0 : _T_458; // @[Lookup.scala 11:37]
  assign _T_460 = _T_72 ? 4'h0 : _T_459; // @[Lookup.scala 11:37]
  assign _T_461 = _T_68 ? 4'h0 : _T_460; // @[Lookup.scala 11:37]
  assign _T_462 = _T_64 ? 4'h0 : _T_461; // @[Lookup.scala 11:37]
  assign _T_463 = _T_60 ? 4'h0 : _T_462; // @[Lookup.scala 11:37]
  assign _T_464 = _T_56 ? 4'h0 : _T_463; // @[Lookup.scala 11:37]
  assign _T_465 = _T_52 ? 4'h0 : _T_464; // @[Lookup.scala 11:37]
  assign _T_466 = _T_48 ? 4'h0 : _T_465; // @[Lookup.scala 11:37]
  assign _T_467 = _T_44 ? 4'h0 : _T_466; // @[Lookup.scala 11:37]
  assign _T_468 = _T_40 ? 4'h0 : _T_467; // @[Lookup.scala 11:37]
  assign ctrlSignals_4 = _T_36 ? 4'hb : _T_468; // @[Lookup.scala 11:37]
  assign _T_508 = _T_72 ? 3'h4 : 3'h0; // @[Lookup.scala 11:37]
  assign _T_509 = _T_68 ? 3'h1 : _T_508; // @[Lookup.scala 11:37]
  assign _T_510 = _T_64 ? 3'h5 : _T_509; // @[Lookup.scala 11:37]
  assign _T_511 = _T_60 ? 3'h2 : _T_510; // @[Lookup.scala 11:37]
  assign _T_512 = _T_56 ? 3'h6 : _T_511; // @[Lookup.scala 11:37]
  assign _T_513 = _T_52 ? 3'h3 : _T_512; // @[Lookup.scala 11:37]
  assign _T_514 = _T_48 ? 3'h0 : _T_513; // @[Lookup.scala 11:37]
  assign _T_515 = _T_44 ? 3'h0 : _T_514; // @[Lookup.scala 11:37]
  assign _T_516 = _T_40 ? 3'h0 : _T_515; // @[Lookup.scala 11:37]
  assign ctrlSignals_5 = _T_36 ? 3'h0 : _T_516; // @[Lookup.scala 11:37]
  assign _T_519 = _T_220 ? 1'h0 : _T_224; // @[Lookup.scala 11:37]
  assign _T_520 = _T_216 ? 1'h0 : _T_519; // @[Lookup.scala 11:37]
  assign _T_521 = _T_212 ? 1'h1 : _T_520; // @[Lookup.scala 11:37]
  assign _T_522 = _T_208 ? 1'h1 : _T_521; // @[Lookup.scala 11:37]
  assign _T_523 = _T_204 ? 1'h1 : _T_522; // @[Lookup.scala 11:37]
  assign _T_524 = _T_200 ? 1'h1 : _T_523; // @[Lookup.scala 11:37]
  assign _T_525 = _T_196 ? 1'h1 : _T_524; // @[Lookup.scala 11:37]
  assign _T_526 = _T_192 ? 1'h1 : _T_525; // @[Lookup.scala 11:37]
  assign _T_527 = _T_188 ? 1'h1 : _T_526; // @[Lookup.scala 11:37]
  assign _T_528 = _T_184 ? 1'h0 : _T_527; // @[Lookup.scala 11:37]
  assign _T_529 = _T_180 ? 1'h0 : _T_528; // @[Lookup.scala 11:37]
  assign _T_530 = _T_176 ? 1'h0 : _T_529; // @[Lookup.scala 11:37]
  assign _T_531 = _T_172 ? 1'h0 : _T_530; // @[Lookup.scala 11:37]
  assign _T_532 = _T_168 ? 1'h0 : _T_531; // @[Lookup.scala 11:37]
  assign _T_533 = _T_164 ? 1'h0 : _T_532; // @[Lookup.scala 11:37]
  assign _T_534 = _T_160 ? 1'h0 : _T_533; // @[Lookup.scala 11:37]
  assign _T_535 = _T_156 ? 1'h0 : _T_534; // @[Lookup.scala 11:37]
  assign _T_536 = _T_152 ? 1'h0 : _T_535; // @[Lookup.scala 11:37]
  assign _T_537 = _T_148 ? 1'h0 : _T_536; // @[Lookup.scala 11:37]
  assign _T_538 = _T_144 ? 1'h0 : _T_537; // @[Lookup.scala 11:37]
  assign _T_539 = _T_140 ? 1'h0 : _T_538; // @[Lookup.scala 11:37]
  assign _T_540 = _T_136 ? 1'h0 : _T_539; // @[Lookup.scala 11:37]
  assign _T_541 = _T_132 ? 1'h0 : _T_540; // @[Lookup.scala 11:37]
  assign _T_542 = _T_128 ? 1'h0 : _T_541; // @[Lookup.scala 11:37]
  assign _T_543 = _T_124 ? 1'h0 : _T_542; // @[Lookup.scala 11:37]
  assign _T_544 = _T_120 ? 1'h0 : _T_543; // @[Lookup.scala 11:37]
  assign _T_545 = _T_116 ? 1'h0 : _T_544; // @[Lookup.scala 11:37]
  assign _T_546 = _T_112 ? 1'h0 : _T_545; // @[Lookup.scala 11:37]
  assign _T_547 = _T_108 ? 1'h0 : _T_546; // @[Lookup.scala 11:37]
  assign _T_548 = _T_104 ? 1'h0 : _T_547; // @[Lookup.scala 11:37]
  assign _T_549 = _T_100 ? 1'h0 : _T_548; // @[Lookup.scala 11:37]
  assign _T_550 = _T_96 ? 1'h0 : _T_549; // @[Lookup.scala 11:37]
  assign _T_551 = _T_92 ? 1'h1 : _T_550; // @[Lookup.scala 11:37]
  assign _T_552 = _T_88 ? 1'h1 : _T_551; // @[Lookup.scala 11:37]
  assign _T_553 = _T_84 ? 1'h1 : _T_552; // @[Lookup.scala 11:37]
  assign _T_554 = _T_80 ? 1'h1 : _T_553; // @[Lookup.scala 11:37]
  assign _T_555 = _T_76 ? 1'h1 : _T_554; // @[Lookup.scala 11:37]
  assign _T_556 = _T_72 ? 1'h0 : _T_555; // @[Lookup.scala 11:37]
  assign _T_557 = _T_68 ? 1'h0 : _T_556; // @[Lookup.scala 11:37]
  assign _T_558 = _T_64 ? 1'h0 : _T_557; // @[Lookup.scala 11:37]
  assign _T_559 = _T_60 ? 1'h0 : _T_558; // @[Lookup.scala 11:37]
  assign _T_560 = _T_56 ? 1'h0 : _T_559; // @[Lookup.scala 11:37]
  assign _T_561 = _T_52 ? 1'h0 : _T_560; // @[Lookup.scala 11:37]
  assign _T_562 = _T_48 ? 1'h1 : _T_561; // @[Lookup.scala 11:37]
  assign _T_563 = _T_44 ? 1'h1 : _T_562; // @[Lookup.scala 11:37]
  assign _T_564 = _T_40 ? 1'h0 : _T_563; // @[Lookup.scala 11:37]
  assign ctrlSignals_6 = _T_36 ? 1'h0 : _T_564; // @[Lookup.scala 11:37]
  assign _T_596 = _T_104 ? 2'h1 : 2'h0; // @[Lookup.scala 11:37]
  assign _T_597 = _T_100 ? 2'h2 : _T_596; // @[Lookup.scala 11:37]
  assign _T_598 = _T_96 ? 2'h3 : _T_597; // @[Lookup.scala 11:37]
  assign _T_599 = _T_92 ? 2'h0 : _T_598; // @[Lookup.scala 11:37]
  assign _T_600 = _T_88 ? 2'h0 : _T_599; // @[Lookup.scala 11:37]
  assign _T_601 = _T_84 ? 2'h0 : _T_600; // @[Lookup.scala 11:37]
  assign _T_602 = _T_80 ? 2'h0 : _T_601; // @[Lookup.scala 11:37]
  assign _T_603 = _T_76 ? 2'h0 : _T_602; // @[Lookup.scala 11:37]
  assign _T_604 = _T_72 ? 2'h0 : _T_603; // @[Lookup.scala 11:37]
  assign _T_605 = _T_68 ? 2'h0 : _T_604; // @[Lookup.scala 11:37]
  assign _T_606 = _T_64 ? 2'h0 : _T_605; // @[Lookup.scala 11:37]
  assign _T_607 = _T_60 ? 2'h0 : _T_606; // @[Lookup.scala 11:37]
  assign _T_608 = _T_56 ? 2'h0 : _T_607; // @[Lookup.scala 11:37]
  assign _T_609 = _T_52 ? 2'h0 : _T_608; // @[Lookup.scala 11:37]
  assign _T_610 = _T_48 ? 2'h0 : _T_609; // @[Lookup.scala 11:37]
  assign _T_611 = _T_44 ? 2'h0 : _T_610; // @[Lookup.scala 11:37]
  assign _T_612 = _T_40 ? 2'h0 : _T_611; // @[Lookup.scala 11:37]
  assign ctrlSignals_7 = _T_36 ? 2'h0 : _T_612; // @[Lookup.scala 11:37]
  assign _T_647 = _T_92 ? 3'h4 : 3'h0; // @[Lookup.scala 11:37]
  assign _T_648 = _T_88 ? 3'h5 : _T_647; // @[Lookup.scala 11:37]
  assign _T_649 = _T_84 ? 3'h1 : _T_648; // @[Lookup.scala 11:37]
  assign _T_650 = _T_80 ? 3'h2 : _T_649; // @[Lookup.scala 11:37]
  assign _T_651 = _T_76 ? 3'h3 : _T_650; // @[Lookup.scala 11:37]
  assign _T_652 = _T_72 ? 3'h0 : _T_651; // @[Lookup.scala 11:37]
  assign _T_653 = _T_68 ? 3'h0 : _T_652; // @[Lookup.scala 11:37]
  assign _T_654 = _T_64 ? 3'h0 : _T_653; // @[Lookup.scala 11:37]
  assign _T_655 = _T_60 ? 3'h0 : _T_654; // @[Lookup.scala 11:37]
  assign _T_656 = _T_56 ? 3'h0 : _T_655; // @[Lookup.scala 11:37]
  assign _T_657 = _T_52 ? 3'h0 : _T_656; // @[Lookup.scala 11:37]
  assign _T_658 = _T_48 ? 3'h0 : _T_657; // @[Lookup.scala 11:37]
  assign _T_659 = _T_44 ? 3'h0 : _T_658; // @[Lookup.scala 11:37]
  assign _T_660 = _T_40 ? 3'h0 : _T_659; // @[Lookup.scala 11:37]
  assign ctrlSignals_8 = _T_36 ? 3'h0 : _T_660; // @[Lookup.scala 11:37]
  assign _T_663 = _T_220 ? 2'h3 : _T_230; // @[Lookup.scala 11:37]
  assign _T_664 = _T_216 ? 2'h3 : _T_663; // @[Lookup.scala 11:37]
  assign _T_665 = _T_212 ? 2'h3 : _T_664; // @[Lookup.scala 11:37]
  assign _T_666 = _T_208 ? 2'h3 : _T_665; // @[Lookup.scala 11:37]
  assign _T_667 = _T_204 ? 2'h3 : _T_666; // @[Lookup.scala 11:37]
  assign _T_668 = _T_200 ? 2'h3 : _T_667; // @[Lookup.scala 11:37]
  assign _T_669 = _T_196 ? 2'h3 : _T_668; // @[Lookup.scala 11:37]
  assign _T_670 = _T_192 ? 2'h3 : _T_669; // @[Lookup.scala 11:37]
  assign _T_671 = _T_188 ? 2'h0 : _T_670; // @[Lookup.scala 11:37]
  assign _T_672 = _T_184 ? 2'h0 : _T_671; // @[Lookup.scala 11:37]
  assign _T_673 = _T_180 ? 2'h0 : _T_672; // @[Lookup.scala 11:37]
  assign _T_674 = _T_176 ? 2'h0 : _T_673; // @[Lookup.scala 11:37]
  assign _T_675 = _T_172 ? 2'h0 : _T_674; // @[Lookup.scala 11:37]
  assign _T_676 = _T_168 ? 2'h0 : _T_675; // @[Lookup.scala 11:37]
  assign _T_677 = _T_164 ? 2'h0 : _T_676; // @[Lookup.scala 11:37]
  assign _T_678 = _T_160 ? 2'h0 : _T_677; // @[Lookup.scala 11:37]
  assign _T_679 = _T_156 ? 2'h0 : _T_678; // @[Lookup.scala 11:37]
  assign _T_680 = _T_152 ? 2'h0 : _T_679; // @[Lookup.scala 11:37]
  assign _T_681 = _T_148 ? 2'h0 : _T_680; // @[Lookup.scala 11:37]
  assign _T_682 = _T_144 ? 2'h0 : _T_681; // @[Lookup.scala 11:37]
  assign _T_683 = _T_140 ? 2'h0 : _T_682; // @[Lookup.scala 11:37]
  assign _T_684 = _T_136 ? 2'h0 : _T_683; // @[Lookup.scala 11:37]
  assign _T_685 = _T_132 ? 2'h0 : _T_684; // @[Lookup.scala 11:37]
  assign _T_686 = _T_128 ? 2'h0 : _T_685; // @[Lookup.scala 11:37]
  assign _T_687 = _T_124 ? 2'h0 : _T_686; // @[Lookup.scala 11:37]
  assign _T_688 = _T_120 ? 2'h0 : _T_687; // @[Lookup.scala 11:37]
  assign _T_689 = _T_116 ? 2'h0 : _T_688; // @[Lookup.scala 11:37]
  assign _T_690 = _T_112 ? 2'h0 : _T_689; // @[Lookup.scala 11:37]
  assign _T_691 = _T_108 ? 2'h0 : _T_690; // @[Lookup.scala 11:37]
  assign _T_692 = _T_104 ? 2'h0 : _T_691; // @[Lookup.scala 11:37]
  assign _T_693 = _T_100 ? 2'h0 : _T_692; // @[Lookup.scala 11:37]
  assign _T_694 = _T_96 ? 2'h0 : _T_693; // @[Lookup.scala 11:37]
  assign _T_695 = _T_92 ? 2'h1 : _T_694; // @[Lookup.scala 11:37]
  assign _T_696 = _T_88 ? 2'h1 : _T_695; // @[Lookup.scala 11:37]
  assign _T_697 = _T_84 ? 2'h1 : _T_696; // @[Lookup.scala 11:37]
  assign _T_698 = _T_80 ? 2'h1 : _T_697; // @[Lookup.scala 11:37]
  assign _T_699 = _T_76 ? 2'h1 : _T_698; // @[Lookup.scala 11:37]
  assign _T_700 = _T_72 ? 2'h0 : _T_699; // @[Lookup.scala 11:37]
  assign _T_701 = _T_68 ? 2'h0 : _T_700; // @[Lookup.scala 11:37]
  assign _T_702 = _T_64 ? 2'h0 : _T_701; // @[Lookup.scala 11:37]
  assign _T_703 = _T_60 ? 2'h0 : _T_702; // @[Lookup.scala 11:37]
  assign _T_704 = _T_56 ? 2'h0 : _T_703; // @[Lookup.scala 11:37]
  assign _T_705 = _T_52 ? 2'h0 : _T_704; // @[Lookup.scala 11:37]
  assign _T_706 = _T_48 ? 2'h2 : _T_705; // @[Lookup.scala 11:37]
  assign _T_707 = _T_44 ? 2'h2 : _T_706; // @[Lookup.scala 11:37]
  assign _T_708 = _T_40 ? 2'h0 : _T_707; // @[Lookup.scala 11:37]
  assign ctrlSignals_9 = _T_36 ? 2'h0 : _T_708; // @[Lookup.scala 11:37]
  assign _T_714 = _T_208 ? 1'h1 : _T_212; // @[Lookup.scala 11:37]
  assign _T_715 = _T_204 ? 1'h1 : _T_714; // @[Lookup.scala 11:37]
  assign _T_716 = _T_200 ? 1'h1 : _T_715; // @[Lookup.scala 11:37]
  assign _T_717 = _T_196 ? 1'h1 : _T_716; // @[Lookup.scala 11:37]
  assign _T_718 = _T_192 ? 1'h1 : _T_717; // @[Lookup.scala 11:37]
  assign _T_719 = _T_188 ? 1'h0 : _T_718; // @[Lookup.scala 11:37]
  assign _T_720 = _T_184 ? 1'h0 : _T_719; // @[Lookup.scala 11:37]
  assign _T_721 = _T_180 ? 1'h1 : _T_720; // @[Lookup.scala 11:37]
  assign _T_722 = _T_176 ? 1'h1 : _T_721; // @[Lookup.scala 11:37]
  assign _T_723 = _T_172 ? 1'h1 : _T_722; // @[Lookup.scala 11:37]
  assign _T_724 = _T_168 ? 1'h1 : _T_723; // @[Lookup.scala 11:37]
  assign _T_725 = _T_164 ? 1'h1 : _T_724; // @[Lookup.scala 11:37]
  assign _T_726 = _T_160 ? 1'h1 : _T_725; // @[Lookup.scala 11:37]
  assign _T_727 = _T_156 ? 1'h1 : _T_726; // @[Lookup.scala 11:37]
  assign _T_728 = _T_152 ? 1'h1 : _T_727; // @[Lookup.scala 11:37]
  assign _T_729 = _T_148 ? 1'h1 : _T_728; // @[Lookup.scala 11:37]
  assign _T_730 = _T_144 ? 1'h1 : _T_729; // @[Lookup.scala 11:37]
  assign _T_731 = _T_140 ? 1'h1 : _T_730; // @[Lookup.scala 11:37]
  assign _T_732 = _T_136 ? 1'h1 : _T_731; // @[Lookup.scala 11:37]
  assign _T_733 = _T_132 ? 1'h1 : _T_732; // @[Lookup.scala 11:37]
  assign _T_734 = _T_128 ? 1'h1 : _T_733; // @[Lookup.scala 11:37]
  assign _T_735 = _T_124 ? 1'h1 : _T_734; // @[Lookup.scala 11:37]
  assign _T_736 = _T_120 ? 1'h1 : _T_735; // @[Lookup.scala 11:37]
  assign _T_737 = _T_116 ? 1'h1 : _T_736; // @[Lookup.scala 11:37]
  assign _T_738 = _T_112 ? 1'h1 : _T_737; // @[Lookup.scala 11:37]
  assign _T_739 = _T_108 ? 1'h1 : _T_738; // @[Lookup.scala 11:37]
  assign _T_740 = _T_104 ? 1'h0 : _T_739; // @[Lookup.scala 11:37]
  assign _T_741 = _T_100 ? 1'h0 : _T_740; // @[Lookup.scala 11:37]
  assign _T_742 = _T_96 ? 1'h0 : _T_741; // @[Lookup.scala 11:37]
  assign _T_743 = _T_92 ? 1'h1 : _T_742; // @[Lookup.scala 11:37]
  assign _T_744 = _T_88 ? 1'h1 : _T_743; // @[Lookup.scala 11:37]
  assign _T_745 = _T_84 ? 1'h1 : _T_744; // @[Lookup.scala 11:37]
  assign _T_746 = _T_80 ? 1'h1 : _T_745; // @[Lookup.scala 11:37]
  assign _T_747 = _T_76 ? 1'h1 : _T_746; // @[Lookup.scala 11:37]
  assign _T_748 = _T_72 ? 1'h0 : _T_747; // @[Lookup.scala 11:37]
  assign _T_749 = _T_68 ? 1'h0 : _T_748; // @[Lookup.scala 11:37]
  assign _T_750 = _T_64 ? 1'h0 : _T_749; // @[Lookup.scala 11:37]
  assign _T_751 = _T_60 ? 1'h0 : _T_750; // @[Lookup.scala 11:37]
  assign _T_752 = _T_56 ? 1'h0 : _T_751; // @[Lookup.scala 11:37]
  assign _T_753 = _T_52 ? 1'h0 : _T_752; // @[Lookup.scala 11:37]
  assign _T_754 = _T_48 ? 1'h1 : _T_753; // @[Lookup.scala 11:37]
  assign _T_755 = _T_44 ? 1'h1 : _T_754; // @[Lookup.scala 11:37]
  assign _T_756 = _T_40 ? 1'h1 : _T_755; // @[Lookup.scala 11:37]
  assign ctrlSignals_10 = _T_36 ? 1'h1 : _T_756; // @[Lookup.scala 11:37]
  assign _T_758 = _T_224 ? 3'h4 : 3'h0; // @[Lookup.scala 11:37]
  assign _T_759 = _T_220 ? 3'h4 : _T_758; // @[Lookup.scala 11:37]
  assign _T_760 = _T_216 ? 3'h4 : _T_759; // @[Lookup.scala 11:37]
  assign _T_761 = _T_212 ? 3'h3 : _T_760; // @[Lookup.scala 11:37]
  assign _T_762 = _T_208 ? 3'h2 : _T_761; // @[Lookup.scala 11:37]
  assign _T_763 = _T_204 ? 3'h1 : _T_762; // @[Lookup.scala 11:37]
  assign _T_764 = _T_200 ? 3'h3 : _T_763; // @[Lookup.scala 11:37]
  assign _T_765 = _T_196 ? 3'h2 : _T_764; // @[Lookup.scala 11:37]
  assign _T_766 = _T_192 ? 3'h1 : _T_765; // @[Lookup.scala 11:37]
  assign _T_767 = _T_188 ? 3'h0 : _T_766; // @[Lookup.scala 11:37]
  assign _T_768 = _T_184 ? 3'h0 : _T_767; // @[Lookup.scala 11:37]
  assign _T_769 = _T_180 ? 3'h0 : _T_768; // @[Lookup.scala 11:37]
  assign _T_770 = _T_176 ? 3'h0 : _T_769; // @[Lookup.scala 11:37]
  assign _T_771 = _T_172 ? 3'h0 : _T_770; // @[Lookup.scala 11:37]
  assign _T_772 = _T_168 ? 3'h0 : _T_771; // @[Lookup.scala 11:37]
  assign _T_773 = _T_164 ? 3'h0 : _T_772; // @[Lookup.scala 11:37]
  assign _T_774 = _T_160 ? 3'h0 : _T_773; // @[Lookup.scala 11:37]
  assign _T_775 = _T_156 ? 3'h0 : _T_774; // @[Lookup.scala 11:37]
  assign _T_776 = _T_152 ? 3'h0 : _T_775; // @[Lookup.scala 11:37]
  assign _T_777 = _T_148 ? 3'h0 : _T_776; // @[Lookup.scala 11:37]
  assign _T_778 = _T_144 ? 3'h0 : _T_777; // @[Lookup.scala 11:37]
  assign _T_779 = _T_140 ? 3'h0 : _T_778; // @[Lookup.scala 11:37]
  assign _T_780 = _T_136 ? 3'h0 : _T_779; // @[Lookup.scala 11:37]
  assign _T_781 = _T_132 ? 3'h0 : _T_780; // @[Lookup.scala 11:37]
  assign _T_782 = _T_128 ? 3'h0 : _T_781; // @[Lookup.scala 11:37]
  assign _T_783 = _T_124 ? 3'h0 : _T_782; // @[Lookup.scala 11:37]
  assign _T_784 = _T_120 ? 3'h0 : _T_783; // @[Lookup.scala 11:37]
  assign _T_785 = _T_116 ? 3'h0 : _T_784; // @[Lookup.scala 11:37]
  assign _T_786 = _T_112 ? 3'h0 : _T_785; // @[Lookup.scala 11:37]
  assign _T_787 = _T_108 ? 3'h0 : _T_786; // @[Lookup.scala 11:37]
  assign _T_788 = _T_104 ? 3'h0 : _T_787; // @[Lookup.scala 11:37]
  assign _T_789 = _T_100 ? 3'h0 : _T_788; // @[Lookup.scala 11:37]
  assign _T_790 = _T_96 ? 3'h0 : _T_789; // @[Lookup.scala 11:37]
  assign _T_791 = _T_92 ? 3'h0 : _T_790; // @[Lookup.scala 11:37]
  assign _T_792 = _T_88 ? 3'h0 : _T_791; // @[Lookup.scala 11:37]
  assign _T_793 = _T_84 ? 3'h0 : _T_792; // @[Lookup.scala 11:37]
  assign _T_794 = _T_80 ? 3'h0 : _T_793; // @[Lookup.scala 11:37]
  assign _T_795 = _T_76 ? 3'h0 : _T_794; // @[Lookup.scala 11:37]
  assign _T_796 = _T_72 ? 3'h0 : _T_795; // @[Lookup.scala 11:37]
  assign _T_797 = _T_68 ? 3'h0 : _T_796; // @[Lookup.scala 11:37]
  assign _T_798 = _T_64 ? 3'h0 : _T_797; // @[Lookup.scala 11:37]
  assign _T_799 = _T_60 ? 3'h0 : _T_798; // @[Lookup.scala 11:37]
  assign _T_800 = _T_56 ? 3'h0 : _T_799; // @[Lookup.scala 11:37]
  assign _T_801 = _T_52 ? 3'h0 : _T_800; // @[Lookup.scala 11:37]
  assign _T_802 = _T_48 ? 3'h0 : _T_801; // @[Lookup.scala 11:37]
  assign _T_803 = _T_44 ? 3'h0 : _T_802; // @[Lookup.scala 11:37]
  assign _T_804 = _T_40 ? 3'h0 : _T_803; // @[Lookup.scala 11:37]
  assign ctrlSignals_11 = _T_36 ? 3'h0 : _T_804; // @[Lookup.scala 11:37]
  assign _T_805 = _T_228 ? 1'h0 : 1'h1; // @[Lookup.scala 11:37]
  assign _T_806 = _T_224 ? 1'h0 : _T_805; // @[Lookup.scala 11:37]
  assign _T_807 = _T_220 ? 1'h0 : _T_806; // @[Lookup.scala 11:37]
  assign _T_808 = _T_216 ? 1'h0 : _T_807; // @[Lookup.scala 11:37]
  assign _T_809 = _T_212 ? 1'h0 : _T_808; // @[Lookup.scala 11:37]
  assign _T_810 = _T_208 ? 1'h0 : _T_809; // @[Lookup.scala 11:37]
  assign _T_811 = _T_204 ? 1'h0 : _T_810; // @[Lookup.scala 11:37]
  assign _T_812 = _T_200 ? 1'h0 : _T_811; // @[Lookup.scala 11:37]
  assign _T_813 = _T_196 ? 1'h0 : _T_812; // @[Lookup.scala 11:37]
  assign _T_814 = _T_192 ? 1'h0 : _T_813; // @[Lookup.scala 11:37]
  assign _T_815 = _T_188 ? 1'h0 : _T_814; // @[Lookup.scala 11:37]
  assign _T_816 = _T_184 ? 1'h0 : _T_815; // @[Lookup.scala 11:37]
  assign _T_817 = _T_180 ? 1'h0 : _T_816; // @[Lookup.scala 11:37]
  assign _T_818 = _T_176 ? 1'h0 : _T_817; // @[Lookup.scala 11:37]
  assign _T_819 = _T_172 ? 1'h0 : _T_818; // @[Lookup.scala 11:37]
  assign _T_820 = _T_168 ? 1'h0 : _T_819; // @[Lookup.scala 11:37]
  assign _T_821 = _T_164 ? 1'h0 : _T_820; // @[Lookup.scala 11:37]
  assign _T_822 = _T_160 ? 1'h0 : _T_821; // @[Lookup.scala 11:37]
  assign _T_823 = _T_156 ? 1'h0 : _T_822; // @[Lookup.scala 11:37]
  assign _T_824 = _T_152 ? 1'h0 : _T_823; // @[Lookup.scala 11:37]
  assign _T_825 = _T_148 ? 1'h0 : _T_824; // @[Lookup.scala 11:37]
  assign _T_826 = _T_144 ? 1'h0 : _T_825; // @[Lookup.scala 11:37]
  assign _T_827 = _T_140 ? 1'h0 : _T_826; // @[Lookup.scala 11:37]
  assign _T_828 = _T_136 ? 1'h0 : _T_827; // @[Lookup.scala 11:37]
  assign _T_829 = _T_132 ? 1'h0 : _T_828; // @[Lookup.scala 11:37]
  assign _T_830 = _T_128 ? 1'h0 : _T_829; // @[Lookup.scala 11:37]
  assign _T_831 = _T_124 ? 1'h0 : _T_830; // @[Lookup.scala 11:37]
  assign _T_832 = _T_120 ? 1'h0 : _T_831; // @[Lookup.scala 11:37]
  assign _T_833 = _T_116 ? 1'h0 : _T_832; // @[Lookup.scala 11:37]
  assign _T_834 = _T_112 ? 1'h0 : _T_833; // @[Lookup.scala 11:37]
  assign _T_835 = _T_108 ? 1'h0 : _T_834; // @[Lookup.scala 11:37]
  assign _T_836 = _T_104 ? 1'h0 : _T_835; // @[Lookup.scala 11:37]
  assign _T_837 = _T_100 ? 1'h0 : _T_836; // @[Lookup.scala 11:37]
  assign _T_838 = _T_96 ? 1'h0 : _T_837; // @[Lookup.scala 11:37]
  assign _T_839 = _T_92 ? 1'h0 : _T_838; // @[Lookup.scala 11:37]
  assign _T_840 = _T_88 ? 1'h0 : _T_839; // @[Lookup.scala 11:37]
  assign _T_841 = _T_84 ? 1'h0 : _T_840; // @[Lookup.scala 11:37]
  assign _T_842 = _T_80 ? 1'h0 : _T_841; // @[Lookup.scala 11:37]
  assign _T_843 = _T_76 ? 1'h0 : _T_842; // @[Lookup.scala 11:37]
  assign _T_844 = _T_72 ? 1'h0 : _T_843; // @[Lookup.scala 11:37]
  assign _T_845 = _T_68 ? 1'h0 : _T_844; // @[Lookup.scala 11:37]
  assign _T_846 = _T_64 ? 1'h0 : _T_845; // @[Lookup.scala 11:37]
  assign _T_847 = _T_60 ? 1'h0 : _T_846; // @[Lookup.scala 11:37]
  assign _T_848 = _T_56 ? 1'h0 : _T_847; // @[Lookup.scala 11:37]
  assign _T_849 = _T_52 ? 1'h0 : _T_848; // @[Lookup.scala 11:37]
  assign _T_850 = _T_48 ? 1'h0 : _T_849; // @[Lookup.scala 11:37]
  assign _T_851 = _T_44 ? 1'h0 : _T_850; // @[Lookup.scala 11:37]
  assign _T_852 = _T_40 ? 1'h0 : _T_851; // @[Lookup.scala 11:37]
  assign ctrlSignals_12 = _T_36 ? 1'h0 : _T_852; // @[Lookup.scala 11:37]
  assign io_pc_sel = ctrlSignals_0;
  assign io_inst_kill = ctrlSignals_6;
  assign io_A_sel = ctrlSignals_1;
  assign io_B_sel = ctrlSignals_2;
  assign io_imm_sel = ctrlSignals_3;
  assign io_alu_op = ctrlSignals_4;
  assign io_br_type = ctrlSignals_5;
  assign io_st_type = ctrlSignals_7;
  assign io_ld_type = ctrlSignals_8;
  assign io_wb_sel = ctrlSignals_9;
  assign io_wb_en = ctrlSignals_10;
  assign io_csr_cmd = ctrlSignals_11;
  assign io_illegal = ctrlSignals_12;
endmodule
module Core(
  input         clock,
  input         reset,
  output        io_icache_req_valid,
  output [31:0] io_icache_req_bits_addr,
  input         io_icache_resp_valid,
  input  [31:0] io_icache_resp_bits_data,
  output        io_dcache_abort,
  output        io_dcache_req_valid,
  output [31:0] io_dcache_req_bits_addr,
  output [31:0] io_dcache_req_bits_data,
  output [3:0]  io_dcache_req_bits_mask,
  input         io_dcache_resp_valid,
  input  [31:0] io_dcache_resp_bits_data
);
  wire  dpath_clock; // @[Core.scala 35:21]
  wire  dpath_reset; // @[Core.scala 35:21]
  wire  dpath_io_icache_req_valid; // @[Core.scala 35:21]
  wire [31:0] dpath_io_icache_req_bits_addr; // @[Core.scala 35:21]
  wire  dpath_io_icache_resp_valid; // @[Core.scala 35:21]
  wire [31:0] dpath_io_icache_resp_bits_data; // @[Core.scala 35:21]
  wire  dpath_io_dcache_abort; // @[Core.scala 35:21]
  wire  dpath_io_dcache_req_valid; // @[Core.scala 35:21]
  wire [31:0] dpath_io_dcache_req_bits_addr; // @[Core.scala 35:21]
  wire [31:0] dpath_io_dcache_req_bits_data; // @[Core.scala 35:21]
  wire [3:0] dpath_io_dcache_req_bits_mask; // @[Core.scala 35:21]
  wire  dpath_io_dcache_resp_valid; // @[Core.scala 35:21]
  wire [31:0] dpath_io_dcache_resp_bits_data; // @[Core.scala 35:21]
  wire [31:0] dpath_io_ctrl_inst; // @[Core.scala 35:21]
  wire [1:0] dpath_io_ctrl_pc_sel; // @[Core.scala 35:21]
  wire  dpath_io_ctrl_inst_kill; // @[Core.scala 35:21]
  wire  dpath_io_ctrl_A_sel; // @[Core.scala 35:21]
  wire  dpath_io_ctrl_B_sel; // @[Core.scala 35:21]
  wire [2:0] dpath_io_ctrl_imm_sel; // @[Core.scala 35:21]
  wire [3:0] dpath_io_ctrl_alu_op; // @[Core.scala 35:21]
  wire [2:0] dpath_io_ctrl_br_type; // @[Core.scala 35:21]
  wire [1:0] dpath_io_ctrl_st_type; // @[Core.scala 35:21]
  wire [2:0] dpath_io_ctrl_ld_type; // @[Core.scala 35:21]
  wire [1:0] dpath_io_ctrl_wb_sel; // @[Core.scala 35:21]
  wire  dpath_io_ctrl_wb_en; // @[Core.scala 35:21]
  wire [2:0] dpath_io_ctrl_csr_cmd; // @[Core.scala 35:21]
  wire  dpath_io_ctrl_illegal; // @[Core.scala 35:21]
  wire [31:0] ctrl_io_inst; // @[Core.scala 36:21]
  wire [1:0] ctrl_io_pc_sel; // @[Core.scala 36:21]
  wire  ctrl_io_inst_kill; // @[Core.scala 36:21]
  wire  ctrl_io_A_sel; // @[Core.scala 36:21]
  wire  ctrl_io_B_sel; // @[Core.scala 36:21]
  wire [2:0] ctrl_io_imm_sel; // @[Core.scala 36:21]
  wire [3:0] ctrl_io_alu_op; // @[Core.scala 36:21]
  wire [2:0] ctrl_io_br_type; // @[Core.scala 36:21]
  wire [1:0] ctrl_io_st_type; // @[Core.scala 36:21]
  wire [2:0] ctrl_io_ld_type; // @[Core.scala 36:21]
  wire [1:0] ctrl_io_wb_sel; // @[Core.scala 36:21]
  wire  ctrl_io_wb_en; // @[Core.scala 36:21]
  wire [2:0] ctrl_io_csr_cmd; // @[Core.scala 36:21]
  wire  ctrl_io_illegal; // @[Core.scala 36:21]
  Datapath dpath ( // @[Core.scala 35:21]
    .clock(dpath_clock),
    .reset(dpath_reset),
    .io_icache_req_valid(dpath_io_icache_req_valid),
    .io_icache_req_bits_addr(dpath_io_icache_req_bits_addr),
    .io_icache_resp_valid(dpath_io_icache_resp_valid),
    .io_icache_resp_bits_data(dpath_io_icache_resp_bits_data),
    .io_dcache_abort(dpath_io_dcache_abort),
    .io_dcache_req_valid(dpath_io_dcache_req_valid),
    .io_dcache_req_bits_addr(dpath_io_dcache_req_bits_addr),
    .io_dcache_req_bits_data(dpath_io_dcache_req_bits_data),
    .io_dcache_req_bits_mask(dpath_io_dcache_req_bits_mask),
    .io_dcache_resp_valid(dpath_io_dcache_resp_valid),
    .io_dcache_resp_bits_data(dpath_io_dcache_resp_bits_data),
    .io_ctrl_inst(dpath_io_ctrl_inst),
    .io_ctrl_pc_sel(dpath_io_ctrl_pc_sel),
    .io_ctrl_inst_kill(dpath_io_ctrl_inst_kill),
    .io_ctrl_A_sel(dpath_io_ctrl_A_sel),
    .io_ctrl_B_sel(dpath_io_ctrl_B_sel),
    .io_ctrl_imm_sel(dpath_io_ctrl_imm_sel),
    .io_ctrl_alu_op(dpath_io_ctrl_alu_op),
    .io_ctrl_br_type(dpath_io_ctrl_br_type),
    .io_ctrl_st_type(dpath_io_ctrl_st_type),
    .io_ctrl_ld_type(dpath_io_ctrl_ld_type),
    .io_ctrl_wb_sel(dpath_io_ctrl_wb_sel),
    .io_ctrl_wb_en(dpath_io_ctrl_wb_en),
    .io_ctrl_csr_cmd(dpath_io_ctrl_csr_cmd),
    .io_ctrl_illegal(dpath_io_ctrl_illegal)
  );
  Control ctrl ( // @[Core.scala 36:21]
    .io_inst(ctrl_io_inst),
    .io_pc_sel(ctrl_io_pc_sel),
    .io_inst_kill(ctrl_io_inst_kill),
    .io_A_sel(ctrl_io_A_sel),
    .io_B_sel(ctrl_io_B_sel),
    .io_imm_sel(ctrl_io_imm_sel),
    .io_alu_op(ctrl_io_alu_op),
    .io_br_type(ctrl_io_br_type),
    .io_st_type(ctrl_io_st_type),
    .io_ld_type(ctrl_io_ld_type),
    .io_wb_sel(ctrl_io_wb_sel),
    .io_wb_en(ctrl_io_wb_en),
    .io_csr_cmd(ctrl_io_csr_cmd),
    .io_illegal(ctrl_io_illegal)
  );
  assign io_icache_req_valid = dpath_io_icache_req_valid;
  assign io_icache_req_bits_addr = dpath_io_icache_req_bits_addr;
  assign io_dcache_abort = dpath_io_dcache_abort;
  assign io_dcache_req_valid = dpath_io_dcache_req_valid;
  assign io_dcache_req_bits_addr = dpath_io_dcache_req_bits_addr;
  assign io_dcache_req_bits_data = dpath_io_dcache_req_bits_data;
  assign io_dcache_req_bits_mask = dpath_io_dcache_req_bits_mask;
  assign dpath_clock = clock;
  assign dpath_reset = reset;
  assign dpath_io_icache_resp_valid = io_icache_resp_valid;
  assign dpath_io_icache_resp_bits_data = io_icache_resp_bits_data;
  assign dpath_io_dcache_resp_valid = io_dcache_resp_valid;
  assign dpath_io_dcache_resp_bits_data = io_dcache_resp_bits_data;
  assign dpath_io_ctrl_pc_sel = ctrl_io_pc_sel;
  assign dpath_io_ctrl_inst_kill = ctrl_io_inst_kill;
  assign dpath_io_ctrl_A_sel = ctrl_io_A_sel;
  assign dpath_io_ctrl_B_sel = ctrl_io_B_sel;
  assign dpath_io_ctrl_imm_sel = ctrl_io_imm_sel;
  assign dpath_io_ctrl_alu_op = ctrl_io_alu_op;
  assign dpath_io_ctrl_br_type = ctrl_io_br_type;
  assign dpath_io_ctrl_st_type = ctrl_io_st_type;
  assign dpath_io_ctrl_ld_type = ctrl_io_ld_type;
  assign dpath_io_ctrl_wb_sel = ctrl_io_wb_sel;
  assign dpath_io_ctrl_wb_en = ctrl_io_wb_en;
  assign dpath_io_ctrl_csr_cmd = ctrl_io_csr_cmd;
  assign dpath_io_ctrl_illegal = ctrl_io_illegal;
  assign ctrl_io_inst = dpath_io_ctrl_inst;
endmodule
module Cache(
  input         clock,
  input         reset,
  input         io_cpu_abort,
  input         io_cpu_req_valid,
  input  [31:0] io_cpu_req_bits_addr,
  input  [31:0] io_cpu_req_bits_data,
  input  [3:0]  io_cpu_req_bits_mask,
  output        io_cpu_resp_valid,
  output [31:0] io_cpu_resp_bits_data,
  input         io_nasti_aw_ready,
  output        io_nasti_aw_valid,
  output [31:0] io_nasti_aw_bits_addr,
  input         io_nasti_w_ready,
  output        io_nasti_w_valid,
  output [63:0] io_nasti_w_bits_data,
  output        io_nasti_w_bits_last,
  output        io_nasti_b_ready,
  input         io_nasti_b_valid,
  input         io_nasti_ar_ready,
  output        io_nasti_ar_valid,
  output [31:0] io_nasti_ar_bits_addr,
  output        io_nasti_r_ready,
  input         io_nasti_r_valid,
  input  [63:0] io_nasti_r_bits_data
);
  reg [2:0] state; // @[Cache.scala 59:22]
  reg [31:0] _RAND_0;
  reg [255:0] v; // @[Cache.scala 61:25]
  reg [255:0] _RAND_1;
  reg [255:0] d; // @[Cache.scala 62:25]
  reg [255:0] _RAND_2;
  reg [19:0] metaMem_tag [0:255]; // @[Cache.scala 63:24]
  reg [31:0] _RAND_3;
  wire [19:0] metaMem_tag_rmeta_data; // @[Cache.scala 63:24]
  wire [7:0] metaMem_tag_rmeta_addr; // @[Cache.scala 63:24]
  wire [19:0] metaMem_tag__T_293_data; // @[Cache.scala 63:24]
  wire [7:0] metaMem_tag__T_293_addr; // @[Cache.scala 63:24]
  wire  metaMem_tag__T_293_mask; // @[Cache.scala 63:24]
  wire  metaMem_tag__T_293_en; // @[Cache.scala 63:24]
  wire  _GEN_142;
  reg [7:0] metaMem_tag_rmeta_addr_pipe_0;
  reg [31:0] _RAND_4;
  reg [7:0] dataMem_0_0 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_5;
  wire [7:0] dataMem_0_0__T_150_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_0__T_150_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_0__T_312_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_0__T_312_addr; // @[Cache.scala 64:41]
  wire  dataMem_0_0__T_312_mask; // @[Cache.scala 64:41]
  wire  dataMem_0_0__T_312_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_0_0__T_150_addr_pipe_0;
  reg [31:0] _RAND_6;
  reg [7:0] dataMem_0_1 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_7;
  wire [7:0] dataMem_0_1__T_150_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_1__T_150_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_1__T_312_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_1__T_312_addr; // @[Cache.scala 64:41]
  wire  dataMem_0_1__T_312_mask; // @[Cache.scala 64:41]
  wire  dataMem_0_1__T_312_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_0_1__T_150_addr_pipe_0;
  reg [31:0] _RAND_8;
  reg [7:0] dataMem_0_2 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_9;
  wire [7:0] dataMem_0_2__T_150_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_2__T_150_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_2__T_312_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_2__T_312_addr; // @[Cache.scala 64:41]
  wire  dataMem_0_2__T_312_mask; // @[Cache.scala 64:41]
  wire  dataMem_0_2__T_312_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_0_2__T_150_addr_pipe_0;
  reg [31:0] _RAND_10;
  reg [7:0] dataMem_0_3 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_11;
  wire [7:0] dataMem_0_3__T_150_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_3__T_150_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_3__T_312_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_0_3__T_312_addr; // @[Cache.scala 64:41]
  wire  dataMem_0_3__T_312_mask; // @[Cache.scala 64:41]
  wire  dataMem_0_3__T_312_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_0_3__T_150_addr_pipe_0;
  reg [31:0] _RAND_12;
  reg [7:0] dataMem_1_0 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_13;
  wire [7:0] dataMem_1_0__T_170_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_0__T_170_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_0__T_342_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_0__T_342_addr; // @[Cache.scala 64:41]
  wire  dataMem_1_0__T_342_mask; // @[Cache.scala 64:41]
  wire  dataMem_1_0__T_342_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_1_0__T_170_addr_pipe_0;
  reg [31:0] _RAND_14;
  reg [7:0] dataMem_1_1 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_15;
  wire [7:0] dataMem_1_1__T_170_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_1__T_170_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_1__T_342_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_1__T_342_addr; // @[Cache.scala 64:41]
  wire  dataMem_1_1__T_342_mask; // @[Cache.scala 64:41]
  wire  dataMem_1_1__T_342_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_1_1__T_170_addr_pipe_0;
  reg [31:0] _RAND_16;
  reg [7:0] dataMem_1_2 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_17;
  wire [7:0] dataMem_1_2__T_170_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_2__T_170_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_2__T_342_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_2__T_342_addr; // @[Cache.scala 64:41]
  wire  dataMem_1_2__T_342_mask; // @[Cache.scala 64:41]
  wire  dataMem_1_2__T_342_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_1_2__T_170_addr_pipe_0;
  reg [31:0] _RAND_18;
  reg [7:0] dataMem_1_3 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_19;
  wire [7:0] dataMem_1_3__T_170_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_3__T_170_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_3__T_342_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_1_3__T_342_addr; // @[Cache.scala 64:41]
  wire  dataMem_1_3__T_342_mask; // @[Cache.scala 64:41]
  wire  dataMem_1_3__T_342_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_1_3__T_170_addr_pipe_0;
  reg [31:0] _RAND_20;
  reg [7:0] dataMem_2_0 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_21;
  wire [7:0] dataMem_2_0__T_190_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_0__T_190_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_0__T_372_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_0__T_372_addr; // @[Cache.scala 64:41]
  wire  dataMem_2_0__T_372_mask; // @[Cache.scala 64:41]
  wire  dataMem_2_0__T_372_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_2_0__T_190_addr_pipe_0;
  reg [31:0] _RAND_22;
  reg [7:0] dataMem_2_1 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_23;
  wire [7:0] dataMem_2_1__T_190_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_1__T_190_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_1__T_372_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_1__T_372_addr; // @[Cache.scala 64:41]
  wire  dataMem_2_1__T_372_mask; // @[Cache.scala 64:41]
  wire  dataMem_2_1__T_372_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_2_1__T_190_addr_pipe_0;
  reg [31:0] _RAND_24;
  reg [7:0] dataMem_2_2 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_25;
  wire [7:0] dataMem_2_2__T_190_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_2__T_190_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_2__T_372_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_2__T_372_addr; // @[Cache.scala 64:41]
  wire  dataMem_2_2__T_372_mask; // @[Cache.scala 64:41]
  wire  dataMem_2_2__T_372_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_2_2__T_190_addr_pipe_0;
  reg [31:0] _RAND_26;
  reg [7:0] dataMem_2_3 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_27;
  wire [7:0] dataMem_2_3__T_190_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_3__T_190_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_3__T_372_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_2_3__T_372_addr; // @[Cache.scala 64:41]
  wire  dataMem_2_3__T_372_mask; // @[Cache.scala 64:41]
  wire  dataMem_2_3__T_372_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_2_3__T_190_addr_pipe_0;
  reg [31:0] _RAND_28;
  reg [7:0] dataMem_3_0 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_29;
  wire [7:0] dataMem_3_0__T_210_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_0__T_210_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_0__T_402_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_0__T_402_addr; // @[Cache.scala 64:41]
  wire  dataMem_3_0__T_402_mask; // @[Cache.scala 64:41]
  wire  dataMem_3_0__T_402_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_3_0__T_210_addr_pipe_0;
  reg [31:0] _RAND_30;
  reg [7:0] dataMem_3_1 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_31;
  wire [7:0] dataMem_3_1__T_210_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_1__T_210_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_1__T_402_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_1__T_402_addr; // @[Cache.scala 64:41]
  wire  dataMem_3_1__T_402_mask; // @[Cache.scala 64:41]
  wire  dataMem_3_1__T_402_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_3_1__T_210_addr_pipe_0;
  reg [31:0] _RAND_32;
  reg [7:0] dataMem_3_2 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_33;
  wire [7:0] dataMem_3_2__T_210_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_2__T_210_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_2__T_402_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_2__T_402_addr; // @[Cache.scala 64:41]
  wire  dataMem_3_2__T_402_mask; // @[Cache.scala 64:41]
  wire  dataMem_3_2__T_402_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_3_2__T_210_addr_pipe_0;
  reg [31:0] _RAND_34;
  reg [7:0] dataMem_3_3 [0:255]; // @[Cache.scala 64:41]
  reg [31:0] _RAND_35;
  wire [7:0] dataMem_3_3__T_210_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_3__T_210_addr; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_3__T_402_data; // @[Cache.scala 64:41]
  wire [7:0] dataMem_3_3__T_402_addr; // @[Cache.scala 64:41]
  wire  dataMem_3_3__T_402_mask; // @[Cache.scala 64:41]
  wire  dataMem_3_3__T_402_en; // @[Cache.scala 64:41]
  reg [7:0] dataMem_3_3__T_210_addr_pipe_0;
  reg [31:0] _RAND_36;
  reg [31:0] addr_reg; // @[Cache.scala 66:21]
  reg [31:0] _RAND_37;
  reg [31:0] cpu_data; // @[Cache.scala 67:21]
  reg [31:0] _RAND_38;
  reg [3:0] cpu_mask; // @[Cache.scala 68:21]
  reg [31:0] _RAND_39;
  reg  value; // @[Counter.scala 26:33]
  reg [31:0] _RAND_40;
  reg  value_1; // @[Counter.scala 26:33]
  reg [31:0] _RAND_41;
  reg  is_alloc_reg; // @[Cache.scala 79:29]
  reg [31:0] _RAND_42;
  reg  ren_reg; // @[Cache.scala 84:24]
  reg [31:0] _RAND_43;
  reg [127:0] rdata_buf; // @[Reg.scala 11:16]
  reg [127:0] _RAND_44;
  reg [63:0] refill_buf_0; // @[Cache.scala 95:23]
  reg [63:0] _RAND_45;
  reg [63:0] refill_buf_1; // @[Cache.scala 95:23]
  reg [63:0] _RAND_46;
  wire  _T_111; // @[Decoupled.scala 37:37]
  wire [1:0] _T_117; // @[Counter.scala 35:22]
  wire  _T_118; // @[Counter.scala 35:22]
  wire  _GEN_0; // @[Counter.scala 63:17]
  wire  read_wrap_out; // @[Counter.scala 64:20]
  wire  _T_119; // @[Decoupled.scala 37:37]
  wire [1:0] _T_125; // @[Counter.scala 35:22]
  wire  _T_126; // @[Counter.scala 35:22]
  wire  _GEN_1; // @[Counter.scala 63:17]
  wire  write_wrap_out; // @[Counter.scala 64:20]
  wire  is_idle; // @[Cache.scala 75:25]
  wire  is_read; // @[Cache.scala 76:25]
  wire  is_write; // @[Cache.scala 77:25]
  wire  _T_127; // @[Cache.scala 78:25]
  wire  is_alloc; // @[Cache.scala 78:38]
  wire [7:0] idx_reg; // @[Cache.scala 89:26]
  wire [255:0] _T_237; // @[Cache.scala 98:11]
  wire  _T_238; // @[Cache.scala 98:11]
  wire [19:0] tag_reg; // @[Cache.scala 88:26]
  wire  _T_239; // @[Cache.scala 98:34]
  wire  hit; // @[Cache.scala 98:21]
  wire  _T_130; // @[Cache.scala 82:30]
  wire  _T_131; // @[Cache.scala 82:22]
  wire  _T_133; // @[Cache.scala 82:50]
  wire  _T_134; // @[Cache.scala 82:47]
  wire  wen; // @[Cache.scala 82:64]
  wire  _T_136; // @[Cache.scala 83:13]
  wire  _T_137; // @[Cache.scala 83:30]
  wire  _T_138; // @[Cache.scala 83:18]
  wire  ren; // @[Cache.scala 83:42]
  wire [7:0] idx; // @[Cache.scala 87:22]
  wire [1:0] off_reg; // @[Cache.scala 90:26]
  wire [15:0] _T_162; // @[Cache.scala 93:50]
  wire [15:0] _T_163; // @[Cache.scala 93:50]
  wire [31:0] _T_164; // @[Cache.scala 93:50]
  wire [15:0] _T_182; // @[Cache.scala 93:50]
  wire [15:0] _T_183; // @[Cache.scala 93:50]
  wire [31:0] _T_184; // @[Cache.scala 93:50]
  wire [15:0] _T_202; // @[Cache.scala 93:50]
  wire [15:0] _T_203; // @[Cache.scala 93:50]
  wire [31:0] _T_204; // @[Cache.scala 93:50]
  wire [15:0] _T_222; // @[Cache.scala 93:50]
  wire [15:0] _T_223; // @[Cache.scala 93:50]
  wire [31:0] _T_224; // @[Cache.scala 93:50]
  wire [63:0] _T_225; // @[Cat.scala 30:58]
  wire [63:0] _T_226; // @[Cat.scala 30:58]
  wire [127:0] rdata; // @[Cat.scala 30:58]
  wire [127:0] _GEN_10; // @[Reg.scala 12:19]
  wire [127:0] _T_235; // @[Cache.scala 96:43]
  wire [127:0] read; // @[Cache.scala 96:17]
  wire [31:0] _T_241; // @[Cache.scala 101:58]
  wire [31:0] _T_242; // @[Cache.scala 101:58]
  wire [31:0] _T_243; // @[Cache.scala 101:58]
  wire [31:0] _T_244; // @[Cache.scala 101:58]
  wire [31:0] _GEN_12; // @[Cache.scala 101:25]
  wire [31:0] _GEN_13; // @[Cache.scala 101:25]
  wire [31:0] _GEN_14; // @[Cache.scala 101:25]
  wire  _T_255; // @[Cache.scala 102:47]
  wire  _T_256; // @[Cache.scala 102:36]
  wire  _T_258; // @[Cache.scala 102:83]
  wire  _T_260; // @[Cache.scala 102:73]
  wire  _T_261; // @[Cache.scala 102:70]
  wire  _T_262; // @[Cache.scala 102:54]
  wire [31:0] _GEN_15; // @[Cache.scala 104:27]
  wire [31:0] _GEN_16; // @[Cache.scala 104:27]
  wire [3:0] _GEN_17; // @[Cache.scala 104:27]
  wire  _T_265; // @[Cache.scala 113:19]
  wire [3:0] _T_267; // @[Cat.scala 30:58]
  wire [18:0] _GEN_244; // @[Cache.scala 113:40]
  wire [18:0] _T_268; // @[Cache.scala 113:40]
  wire [19:0] _T_269; // @[Cache.scala 113:80]
  wire [19:0] wmask; // @[Cache.scala 113:18]
  wire [63:0] _T_273; // @[Cat.scala 30:58]
  wire [127:0] _T_274; // @[Cat.scala 30:58]
  wire [127:0] _T_275; // @[Cat.scala 30:58]
  wire [127:0] wdata; // @[Cache.scala 114:18]
  wire [255:0] _T_278; // @[Cache.scala 118:18]
  wire [255:0] _T_279; // @[Cache.scala 118:18]
  wire [255:0] _T_288; // @[Cache.scala 119:18]
  wire [255:0] _T_289; // @[Cache.scala 119:18]
  wire [255:0] _T_290; // @[Cache.scala 119:18]
  wire [255:0] _T_291; // @[Cache.scala 119:18]
  wire [255:0] _T_292; // @[Cache.scala 119:18]
  wire [7:0] _T_294; // @[Cache.scala 124:49]
  wire [7:0] _T_295; // @[Cache.scala 124:49]
  wire [7:0] _T_296; // @[Cache.scala 124:49]
  wire [7:0] _T_297; // @[Cache.scala 124:49]
  wire [3:0] _T_307; // @[Cache.scala 125:37]
  wire  _T_308; // @[Cache.scala 125:64]
  wire  _T_309; // @[Cache.scala 125:64]
  wire  _T_310; // @[Cache.scala 125:64]
  wire  _T_311; // @[Cache.scala 125:64]
  wire [7:0] _T_324; // @[Cache.scala 124:49]
  wire [7:0] _T_325; // @[Cache.scala 124:49]
  wire [7:0] _T_326; // @[Cache.scala 124:49]
  wire [7:0] _T_327; // @[Cache.scala 124:49]
  wire [3:0] _T_337; // @[Cache.scala 125:37]
  wire  _T_338; // @[Cache.scala 125:64]
  wire  _T_339; // @[Cache.scala 125:64]
  wire  _T_340; // @[Cache.scala 125:64]
  wire  _T_341; // @[Cache.scala 125:64]
  wire [7:0] _T_354; // @[Cache.scala 124:49]
  wire [7:0] _T_355; // @[Cache.scala 124:49]
  wire [7:0] _T_356; // @[Cache.scala 124:49]
  wire [7:0] _T_357; // @[Cache.scala 124:49]
  wire [3:0] _T_367; // @[Cache.scala 125:37]
  wire  _T_368; // @[Cache.scala 125:64]
  wire  _T_369; // @[Cache.scala 125:64]
  wire  _T_370; // @[Cache.scala 125:64]
  wire  _T_371; // @[Cache.scala 125:64]
  wire [7:0] _T_384; // @[Cache.scala 124:49]
  wire [7:0] _T_385; // @[Cache.scala 124:49]
  wire [7:0] _T_386; // @[Cache.scala 124:49]
  wire [7:0] _T_387; // @[Cache.scala 124:49]
  wire [3:0] _T_397; // @[Cache.scala 125:37]
  wire  _T_398; // @[Cache.scala 125:64]
  wire  _T_399; // @[Cache.scala 125:64]
  wire  _T_400; // @[Cache.scala 125:64]
  wire  _T_401; // @[Cache.scala 125:64]
  wire [255:0] _GEN_54; // @[Cache.scala 117:13]
  wire [255:0] _GEN_55; // @[Cache.scala 117:13]
  wire  _GEN_58; // @[Cache.scala 117:13]
  wire  _GEN_64; // @[Cache.scala 117:13]
  wire  _GEN_66; // @[Cache.scala 117:13]
  wire  _GEN_68; // @[Cache.scala 117:13]
  wire  _GEN_70; // @[Cache.scala 117:13]
  wire  _GEN_72; // @[Cache.scala 117:13]
  wire  _GEN_74; // @[Cache.scala 117:13]
  wire  _GEN_76; // @[Cache.scala 117:13]
  wire  _GEN_78; // @[Cache.scala 117:13]
  wire  _GEN_80; // @[Cache.scala 117:13]
  wire  _GEN_82; // @[Cache.scala 117:13]
  wire  _GEN_84; // @[Cache.scala 117:13]
  wire  _GEN_86; // @[Cache.scala 117:13]
  wire  _GEN_88; // @[Cache.scala 117:13]
  wire  _GEN_90; // @[Cache.scala 117:13]
  wire  _GEN_92; // @[Cache.scala 117:13]
  wire  _GEN_94; // @[Cache.scala 117:13]
  wire [27:0] _T_415; // @[Cat.scala 30:58]
  wire [34:0] _GEN_245; // @[Cache.scala 131:32]
  wire [34:0] _T_417; // @[Cache.scala 131:32]
  wire [63:0] _GEN_95; // @[Cache.scala 135:52]
  wire [63:0] _GEN_96; // @[Cache.scala 135:52]
  wire [63:0] _GEN_97; // @[Cache.scala 135:27]
  wire [63:0] _GEN_98; // @[Cache.scala 135:27]
  wire [27:0] _T_438; // @[Cat.scala 30:58]
  wire [34:0] _GEN_246; // @[Cache.scala 139:34]
  wire [34:0] _T_440; // @[Cache.scala 139:34]
  wire [63:0] _T_457; // @[Cache.scala 143:38]
  wire [63:0] _T_458; // @[Cache.scala 143:38]
  wire [63:0] _GEN_100; // @[nasti.scala 200:12]
  wire [255:0] _T_480; // @[Cache.scala 150:33]
  wire  _T_481; // @[Cache.scala 150:33]
  wire  is_dirty; // @[Cache.scala 150:29]
  wire  _T_482; // @[Conditional.scala 37:30]
  wire  _T_484; // @[Cache.scala 154:43]
  wire [2:0] _T_485; // @[Cache.scala 154:21]
  wire [2:0] _GEN_101; // @[Cache.scala 153:30]
  wire  _T_486; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_102; // @[Cache.scala 159:32]
  wire  _T_491; // @[Cache.scala 166:30]
  wire  _T_492; // @[Decoupled.scala 37:37]
  wire  _T_493; // @[Decoupled.scala 37:37]
  wire [2:0] _GEN_103; // @[Cache.scala 169:40]
  wire [2:0] _GEN_104; // @[Cache.scala 167:34]
  wire [2:0] _GEN_105; // @[Cache.scala 158:17]
  wire  _GEN_106; // @[Cache.scala 158:17]
  wire  _GEN_107; // @[Cache.scala 158:17]
  wire  _T_494; // @[Conditional.scala 37:30]
  wire  _T_496; // @[Cache.scala 175:32]
  wire [2:0] _GEN_110; // @[Cache.scala 175:49]
  wire  _GEN_111; // @[Cache.scala 175:49]
  wire  _GEN_112; // @[Cache.scala 175:49]
  wire  _T_501; // @[Conditional.scala 37:30]
  wire [2:0] _GEN_113; // @[Cache.scala 189:28]
  wire  _T_503; // @[Conditional.scala 37:30]
  wire  _T_505; // @[Decoupled.scala 37:37]
  wire [2:0] _GEN_114; // @[Cache.scala 195:31]
  wire  _T_506; // @[Conditional.scala 37:30]
  wire  _T_509; // @[Conditional.scala 37:30]
  wire [2:0] _T_512; // @[Cache.scala 207:21]
  wire [2:0] _GEN_116; // @[Cache.scala 206:27]
  wire [2:0] _GEN_117; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_119; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_121; // @[Conditional.scala 39:67]
  wire  _GEN_122; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_124; // @[Conditional.scala 39:67]
  wire  _GEN_125; // @[Conditional.scala 39:67]
  wire  _GEN_126; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_127; // @[Conditional.scala 39:67]
  wire  _GEN_128; // @[Conditional.scala 39:67]
  wire  _GEN_129; // @[Conditional.scala 39:67]
  wire  _GEN_130; // @[Conditional.scala 39:67]
  wire  _GEN_131; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_132; // @[Conditional.scala 39:67]
  wire  _GEN_133; // @[Conditional.scala 39:67]
  wire  _GEN_134; // @[Conditional.scala 39:67]
  wire  _GEN_135; // @[Conditional.scala 39:67]
  wire  _GEN_136; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_137; // @[Conditional.scala 40:58]
  wire  _GEN_138; // @[Conditional.scala 40:58]
  wire  _GEN_139; // @[Conditional.scala 40:58]
  wire  _GEN_140; // @[Conditional.scala 40:58]
  wire  _GEN_141; // @[Conditional.scala 40:58]
  wire [31:0] _T_422_addr; // @[nasti.scala 178:18]
  wire [31:0] _T_445_addr; // @[nasti.scala 158:18]
  assign metaMem_tag_rmeta_addr = metaMem_tag_rmeta_addr_pipe_0;
  assign metaMem_tag_rmeta_data = metaMem_tag[metaMem_tag_rmeta_addr]; // @[Cache.scala 63:24]
  assign metaMem_tag__T_293_data = tag_reg;
  assign metaMem_tag__T_293_addr = idx_reg;
  assign metaMem_tag__T_293_mask = _GEN_58;
  assign metaMem_tag__T_293_en = _GEN_58;
  assign _GEN_142 = ren;
  assign dataMem_0_0__T_150_addr = dataMem_0_0__T_150_addr_pipe_0;
  assign dataMem_0_0__T_150_data = dataMem_0_0[dataMem_0_0__T_150_addr]; // @[Cache.scala 64:41]
  assign dataMem_0_0__T_312_data = _T_294;
  assign dataMem_0_0__T_312_addr = idx_reg;
  assign dataMem_0_0__T_312_mask = _GEN_64;
  assign dataMem_0_0__T_312_en = wen;
  assign dataMem_0_1__T_150_addr = dataMem_0_1__T_150_addr_pipe_0;
  assign dataMem_0_1__T_150_data = dataMem_0_1[dataMem_0_1__T_150_addr]; // @[Cache.scala 64:41]
  assign dataMem_0_1__T_312_data = _T_295;
  assign dataMem_0_1__T_312_addr = idx_reg;
  assign dataMem_0_1__T_312_mask = _GEN_66;
  assign dataMem_0_1__T_312_en = wen;
  assign dataMem_0_2__T_150_addr = dataMem_0_2__T_150_addr_pipe_0;
  assign dataMem_0_2__T_150_data = dataMem_0_2[dataMem_0_2__T_150_addr]; // @[Cache.scala 64:41]
  assign dataMem_0_2__T_312_data = _T_296;
  assign dataMem_0_2__T_312_addr = idx_reg;
  assign dataMem_0_2__T_312_mask = _GEN_68;
  assign dataMem_0_2__T_312_en = wen;
  assign dataMem_0_3__T_150_addr = dataMem_0_3__T_150_addr_pipe_0;
  assign dataMem_0_3__T_150_data = dataMem_0_3[dataMem_0_3__T_150_addr]; // @[Cache.scala 64:41]
  assign dataMem_0_3__T_312_data = _T_297;
  assign dataMem_0_3__T_312_addr = idx_reg;
  assign dataMem_0_3__T_312_mask = _GEN_70;
  assign dataMem_0_3__T_312_en = wen;
  assign dataMem_1_0__T_170_addr = dataMem_1_0__T_170_addr_pipe_0;
  assign dataMem_1_0__T_170_data = dataMem_1_0[dataMem_1_0__T_170_addr]; // @[Cache.scala 64:41]
  assign dataMem_1_0__T_342_data = _T_324;
  assign dataMem_1_0__T_342_addr = idx_reg;
  assign dataMem_1_0__T_342_mask = _GEN_72;
  assign dataMem_1_0__T_342_en = wen;
  assign dataMem_1_1__T_170_addr = dataMem_1_1__T_170_addr_pipe_0;
  assign dataMem_1_1__T_170_data = dataMem_1_1[dataMem_1_1__T_170_addr]; // @[Cache.scala 64:41]
  assign dataMem_1_1__T_342_data = _T_325;
  assign dataMem_1_1__T_342_addr = idx_reg;
  assign dataMem_1_1__T_342_mask = _GEN_74;
  assign dataMem_1_1__T_342_en = wen;
  assign dataMem_1_2__T_170_addr = dataMem_1_2__T_170_addr_pipe_0;
  assign dataMem_1_2__T_170_data = dataMem_1_2[dataMem_1_2__T_170_addr]; // @[Cache.scala 64:41]
  assign dataMem_1_2__T_342_data = _T_326;
  assign dataMem_1_2__T_342_addr = idx_reg;
  assign dataMem_1_2__T_342_mask = _GEN_76;
  assign dataMem_1_2__T_342_en = wen;
  assign dataMem_1_3__T_170_addr = dataMem_1_3__T_170_addr_pipe_0;
  assign dataMem_1_3__T_170_data = dataMem_1_3[dataMem_1_3__T_170_addr]; // @[Cache.scala 64:41]
  assign dataMem_1_3__T_342_data = _T_327;
  assign dataMem_1_3__T_342_addr = idx_reg;
  assign dataMem_1_3__T_342_mask = _GEN_78;
  assign dataMem_1_3__T_342_en = wen;
  assign dataMem_2_0__T_190_addr = dataMem_2_0__T_190_addr_pipe_0;
  assign dataMem_2_0__T_190_data = dataMem_2_0[dataMem_2_0__T_190_addr]; // @[Cache.scala 64:41]
  assign dataMem_2_0__T_372_data = _T_354;
  assign dataMem_2_0__T_372_addr = idx_reg;
  assign dataMem_2_0__T_372_mask = _GEN_80;
  assign dataMem_2_0__T_372_en = wen;
  assign dataMem_2_1__T_190_addr = dataMem_2_1__T_190_addr_pipe_0;
  assign dataMem_2_1__T_190_data = dataMem_2_1[dataMem_2_1__T_190_addr]; // @[Cache.scala 64:41]
  assign dataMem_2_1__T_372_data = _T_355;
  assign dataMem_2_1__T_372_addr = idx_reg;
  assign dataMem_2_1__T_372_mask = _GEN_82;
  assign dataMem_2_1__T_372_en = wen;
  assign dataMem_2_2__T_190_addr = dataMem_2_2__T_190_addr_pipe_0;
  assign dataMem_2_2__T_190_data = dataMem_2_2[dataMem_2_2__T_190_addr]; // @[Cache.scala 64:41]
  assign dataMem_2_2__T_372_data = _T_356;
  assign dataMem_2_2__T_372_addr = idx_reg;
  assign dataMem_2_2__T_372_mask = _GEN_84;
  assign dataMem_2_2__T_372_en = wen;
  assign dataMem_2_3__T_190_addr = dataMem_2_3__T_190_addr_pipe_0;
  assign dataMem_2_3__T_190_data = dataMem_2_3[dataMem_2_3__T_190_addr]; // @[Cache.scala 64:41]
  assign dataMem_2_3__T_372_data = _T_357;
  assign dataMem_2_3__T_372_addr = idx_reg;
  assign dataMem_2_3__T_372_mask = _GEN_86;
  assign dataMem_2_3__T_372_en = wen;
  assign dataMem_3_0__T_210_addr = dataMem_3_0__T_210_addr_pipe_0;
  assign dataMem_3_0__T_210_data = dataMem_3_0[dataMem_3_0__T_210_addr]; // @[Cache.scala 64:41]
  assign dataMem_3_0__T_402_data = _T_384;
  assign dataMem_3_0__T_402_addr = idx_reg;
  assign dataMem_3_0__T_402_mask = _GEN_88;
  assign dataMem_3_0__T_402_en = wen;
  assign dataMem_3_1__T_210_addr = dataMem_3_1__T_210_addr_pipe_0;
  assign dataMem_3_1__T_210_data = dataMem_3_1[dataMem_3_1__T_210_addr]; // @[Cache.scala 64:41]
  assign dataMem_3_1__T_402_data = _T_385;
  assign dataMem_3_1__T_402_addr = idx_reg;
  assign dataMem_3_1__T_402_mask = _GEN_90;
  assign dataMem_3_1__T_402_en = wen;
  assign dataMem_3_2__T_210_addr = dataMem_3_2__T_210_addr_pipe_0;
  assign dataMem_3_2__T_210_data = dataMem_3_2[dataMem_3_2__T_210_addr]; // @[Cache.scala 64:41]
  assign dataMem_3_2__T_402_data = _T_386;
  assign dataMem_3_2__T_402_addr = idx_reg;
  assign dataMem_3_2__T_402_mask = _GEN_92;
  assign dataMem_3_2__T_402_en = wen;
  assign dataMem_3_3__T_210_addr = dataMem_3_3__T_210_addr_pipe_0;
  assign dataMem_3_3__T_210_data = dataMem_3_3[dataMem_3_3__T_210_addr]; // @[Cache.scala 64:41]
  assign dataMem_3_3__T_402_data = _T_387;
  assign dataMem_3_3__T_402_addr = idx_reg;
  assign dataMem_3_3__T_402_mask = _GEN_94;
  assign dataMem_3_3__T_402_en = wen;
  assign _T_111 = io_nasti_r_ready & io_nasti_r_valid; // @[Decoupled.scala 37:37]
  assign _T_117 = value + 1'h1; // @[Counter.scala 35:22]
  assign _T_118 = _T_117[0:0]; // @[Counter.scala 35:22]
  assign _GEN_0 = _T_111 ? _T_118 : value; // @[Counter.scala 63:17]
  assign read_wrap_out = _T_111 & value; // @[Counter.scala 64:20]
  assign _T_119 = io_nasti_w_ready & io_nasti_w_valid; // @[Decoupled.scala 37:37]
  assign _T_125 = value_1 + 1'h1; // @[Counter.scala 35:22]
  assign _T_126 = _T_125[0:0]; // @[Counter.scala 35:22]
  assign _GEN_1 = _T_119 ? _T_126 : value_1; // @[Counter.scala 63:17]
  assign write_wrap_out = _T_119 & value_1; // @[Counter.scala 64:20]
  assign is_idle = state == 3'h0; // @[Cache.scala 75:25]
  assign is_read = state == 3'h1; // @[Cache.scala 76:25]
  assign is_write = state == 3'h2; // @[Cache.scala 77:25]
  assign _T_127 = state == 3'h6; // @[Cache.scala 78:25]
  assign is_alloc = _T_127 & read_wrap_out; // @[Cache.scala 78:38]
  assign idx_reg = addr_reg[11:4]; // @[Cache.scala 89:26]
  assign _T_237 = v >> idx_reg; // @[Cache.scala 98:11]
  assign _T_238 = _T_237[0]; // @[Cache.scala 98:11]
  assign tag_reg = addr_reg[31:12]; // @[Cache.scala 88:26]
  assign _T_239 = metaMem_tag_rmeta_data == tag_reg; // @[Cache.scala 98:34]
  assign hit = _T_238 & _T_239; // @[Cache.scala 98:21]
  assign _T_130 = hit | is_alloc_reg; // @[Cache.scala 82:30]
  assign _T_131 = is_write & _T_130; // @[Cache.scala 82:22]
  assign _T_133 = io_cpu_abort == 1'h0; // @[Cache.scala 82:50]
  assign _T_134 = _T_131 & _T_133; // @[Cache.scala 82:47]
  assign wen = _T_134 | is_alloc; // @[Cache.scala 82:64]
  assign _T_136 = wen == 1'h0; // @[Cache.scala 83:13]
  assign _T_137 = is_idle | is_read; // @[Cache.scala 83:30]
  assign _T_138 = _T_136 & _T_137; // @[Cache.scala 83:18]
  assign ren = _T_138 & io_cpu_req_valid; // @[Cache.scala 83:42]
  assign idx = io_cpu_req_bits_addr[11:4]; // @[Cache.scala 87:22]
  assign off_reg = addr_reg[3:2]; // @[Cache.scala 90:26]
  assign _T_162 = {dataMem_0_1__T_150_data,dataMem_0_0__T_150_data}; // @[Cache.scala 93:50]
  assign _T_163 = {dataMem_0_3__T_150_data,dataMem_0_2__T_150_data}; // @[Cache.scala 93:50]
  assign _T_164 = {_T_163,_T_162}; // @[Cache.scala 93:50]
  assign _T_182 = {dataMem_1_1__T_170_data,dataMem_1_0__T_170_data}; // @[Cache.scala 93:50]
  assign _T_183 = {dataMem_1_3__T_170_data,dataMem_1_2__T_170_data}; // @[Cache.scala 93:50]
  assign _T_184 = {_T_183,_T_182}; // @[Cache.scala 93:50]
  assign _T_202 = {dataMem_2_1__T_190_data,dataMem_2_0__T_190_data}; // @[Cache.scala 93:50]
  assign _T_203 = {dataMem_2_3__T_190_data,dataMem_2_2__T_190_data}; // @[Cache.scala 93:50]
  assign _T_204 = {_T_203,_T_202}; // @[Cache.scala 93:50]
  assign _T_222 = {dataMem_3_1__T_210_data,dataMem_3_0__T_210_data}; // @[Cache.scala 93:50]
  assign _T_223 = {dataMem_3_3__T_210_data,dataMem_3_2__T_210_data}; // @[Cache.scala 93:50]
  assign _T_224 = {_T_223,_T_222}; // @[Cache.scala 93:50]
  assign _T_225 = {_T_184,_T_164}; // @[Cat.scala 30:58]
  assign _T_226 = {_T_224,_T_204}; // @[Cat.scala 30:58]
  assign rdata = {_T_226,_T_225}; // @[Cat.scala 30:58]
  assign _GEN_10 = ren_reg ? rdata : rdata_buf; // @[Reg.scala 12:19]
  assign _T_235 = {refill_buf_1,refill_buf_0}; // @[Cache.scala 96:43]
  assign read = is_alloc_reg ? _T_235 : _GEN_10; // @[Cache.scala 96:17]
  assign _T_241 = read[31:0]; // @[Cache.scala 101:58]
  assign _T_242 = read[63:32]; // @[Cache.scala 101:58]
  assign _T_243 = read[95:64]; // @[Cache.scala 101:58]
  assign _T_244 = read[127:96]; // @[Cache.scala 101:58]
  assign _GEN_12 = 2'h1 == off_reg ? _T_242 : _T_241; // @[Cache.scala 101:25]
  assign _GEN_13 = 2'h2 == off_reg ? _T_243 : _GEN_12; // @[Cache.scala 101:25]
  assign _GEN_14 = 2'h3 == off_reg ? _T_244 : _GEN_13; // @[Cache.scala 101:25]
  assign _T_255 = is_read & hit; // @[Cache.scala 102:47]
  assign _T_256 = is_idle | _T_255; // @[Cache.scala 102:36]
  assign _T_258 = cpu_mask != 4'h0; // @[Cache.scala 102:83]
  assign _T_260 = _T_258 == 1'h0; // @[Cache.scala 102:73]
  assign _T_261 = is_alloc_reg & _T_260; // @[Cache.scala 102:70]
  assign _T_262 = _T_256 | _T_261; // @[Cache.scala 102:54]
  assign _GEN_15 = io_cpu_resp_valid ? io_cpu_req_bits_addr : addr_reg; // @[Cache.scala 104:27]
  assign _GEN_16 = io_cpu_resp_valid ? io_cpu_req_bits_data : cpu_data; // @[Cache.scala 104:27]
  assign _GEN_17 = io_cpu_resp_valid ? io_cpu_req_bits_mask : cpu_mask; // @[Cache.scala 104:27]
  assign _T_265 = is_alloc == 1'h0; // @[Cache.scala 113:19]
  assign _T_267 = {off_reg,2'h0}; // @[Cat.scala 30:58]
  assign _GEN_244 = {{15'd0}, cpu_mask}; // @[Cache.scala 113:40]
  assign _T_268 = _GEN_244 << _T_267; // @[Cache.scala 113:40]
  assign _T_269 = {1'b0,$signed(_T_268)}; // @[Cache.scala 113:80]
  assign wmask = _T_265 ? $signed(_T_269) : $signed(-20'sh1); // @[Cache.scala 113:18]
  assign _T_273 = {cpu_data,cpu_data}; // @[Cat.scala 30:58]
  assign _T_274 = {_T_273,_T_273}; // @[Cat.scala 30:58]
  assign _T_275 = {io_nasti_r_bits_data,refill_buf_0}; // @[Cat.scala 30:58]
  assign wdata = _T_265 ? _T_274 : _T_275; // @[Cache.scala 114:18]
  assign _T_278 = 256'h1 << idx_reg; // @[Cache.scala 118:18]
  assign _T_279 = v | _T_278; // @[Cache.scala 118:18]
  assign _T_288 = d | _T_278; // @[Cache.scala 119:18]
  assign _T_289 = ~ d; // @[Cache.scala 119:18]
  assign _T_290 = _T_289 | _T_278; // @[Cache.scala 119:18]
  assign _T_291 = ~ _T_290; // @[Cache.scala 119:18]
  assign _T_292 = _T_265 ? _T_288 : _T_291; // @[Cache.scala 119:18]
  assign _T_294 = wdata[7:0]; // @[Cache.scala 124:49]
  assign _T_295 = wdata[15:8]; // @[Cache.scala 124:49]
  assign _T_296 = wdata[23:16]; // @[Cache.scala 124:49]
  assign _T_297 = wdata[31:24]; // @[Cache.scala 124:49]
  assign _T_307 = wmask[3:0]; // @[Cache.scala 125:37]
  assign _T_308 = _T_307[0]; // @[Cache.scala 125:64]
  assign _T_309 = _T_307[1]; // @[Cache.scala 125:64]
  assign _T_310 = _T_307[2]; // @[Cache.scala 125:64]
  assign _T_311 = _T_307[3]; // @[Cache.scala 125:64]
  assign _T_324 = wdata[39:32]; // @[Cache.scala 124:49]
  assign _T_325 = wdata[47:40]; // @[Cache.scala 124:49]
  assign _T_326 = wdata[55:48]; // @[Cache.scala 124:49]
  assign _T_327 = wdata[63:56]; // @[Cache.scala 124:49]
  assign _T_337 = wmask[7:4]; // @[Cache.scala 125:37]
  assign _T_338 = _T_337[0]; // @[Cache.scala 125:64]
  assign _T_339 = _T_337[1]; // @[Cache.scala 125:64]
  assign _T_340 = _T_337[2]; // @[Cache.scala 125:64]
  assign _T_341 = _T_337[3]; // @[Cache.scala 125:64]
  assign _T_354 = wdata[71:64]; // @[Cache.scala 124:49]
  assign _T_355 = wdata[79:72]; // @[Cache.scala 124:49]
  assign _T_356 = wdata[87:80]; // @[Cache.scala 124:49]
  assign _T_357 = wdata[95:88]; // @[Cache.scala 124:49]
  assign _T_367 = wmask[11:8]; // @[Cache.scala 125:37]
  assign _T_368 = _T_367[0]; // @[Cache.scala 125:64]
  assign _T_369 = _T_367[1]; // @[Cache.scala 125:64]
  assign _T_370 = _T_367[2]; // @[Cache.scala 125:64]
  assign _T_371 = _T_367[3]; // @[Cache.scala 125:64]
  assign _T_384 = wdata[103:96]; // @[Cache.scala 124:49]
  assign _T_385 = wdata[111:104]; // @[Cache.scala 124:49]
  assign _T_386 = wdata[119:112]; // @[Cache.scala 124:49]
  assign _T_387 = wdata[127:120]; // @[Cache.scala 124:49]
  assign _T_397 = wmask[15:12]; // @[Cache.scala 125:37]
  assign _T_398 = _T_397[0]; // @[Cache.scala 125:64]
  assign _T_399 = _T_397[1]; // @[Cache.scala 125:64]
  assign _T_400 = _T_397[2]; // @[Cache.scala 125:64]
  assign _T_401 = _T_397[3]; // @[Cache.scala 125:64]
  assign _GEN_54 = wen ? _T_279 : v; // @[Cache.scala 117:13]
  assign _GEN_55 = wen ? _T_292 : d; // @[Cache.scala 117:13]
  assign _GEN_58 = wen ? is_alloc : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_64 = wen ? _T_308 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_66 = wen ? _T_309 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_68 = wen ? _T_310 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_70 = wen ? _T_311 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_72 = wen ? _T_338 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_74 = wen ? _T_339 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_76 = wen ? _T_340 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_78 = wen ? _T_341 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_80 = wen ? _T_368 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_82 = wen ? _T_369 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_84 = wen ? _T_370 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_86 = wen ? _T_371 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_88 = wen ? _T_398 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_90 = wen ? _T_399 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_92 = wen ? _T_400 : 1'h0; // @[Cache.scala 117:13]
  assign _GEN_94 = wen ? _T_401 : 1'h0; // @[Cache.scala 117:13]
  assign _T_415 = {tag_reg,idx_reg}; // @[Cat.scala 30:58]
  assign _GEN_245 = {{7'd0}, _T_415}; // @[Cache.scala 131:32]
  assign _T_417 = _GEN_245 << 3'h4; // @[Cache.scala 131:32]
  assign _GEN_95 = 1'h0 == value ? io_nasti_r_bits_data : refill_buf_0; // @[Cache.scala 135:52]
  assign _GEN_96 = value ? io_nasti_r_bits_data : refill_buf_1; // @[Cache.scala 135:52]
  assign _GEN_97 = _T_111 ? _GEN_95 : refill_buf_0; // @[Cache.scala 135:27]
  assign _GEN_98 = _T_111 ? _GEN_96 : refill_buf_1; // @[Cache.scala 135:27]
  assign _T_438 = {metaMem_tag_rmeta_data,idx_reg}; // @[Cat.scala 30:58]
  assign _GEN_246 = {{7'd0}, _T_438}; // @[Cache.scala 139:34]
  assign _T_440 = _GEN_246 << 3'h4; // @[Cache.scala 139:34]
  assign _T_457 = read[63:0]; // @[Cache.scala 143:38]
  assign _T_458 = read[127:64]; // @[Cache.scala 143:38]
  assign _GEN_100 = value_1 ? _T_458 : _T_457; // @[nasti.scala 200:12]
  assign _T_480 = d >> idx_reg; // @[Cache.scala 150:33]
  assign _T_481 = _T_480[0]; // @[Cache.scala 150:33]
  assign is_dirty = _T_238 & _T_481; // @[Cache.scala 150:29]
  assign _T_482 = 3'h0 == state; // @[Conditional.scala 37:30]
  assign _T_484 = io_cpu_req_bits_mask != 4'h0; // @[Cache.scala 154:43]
  assign _T_485 = _T_484 ? 3'h2 : 3'h1; // @[Cache.scala 154:21]
  assign _GEN_101 = io_cpu_req_valid ? _T_485 : state; // @[Cache.scala 153:30]
  assign _T_486 = 3'h1 == state; // @[Conditional.scala 37:30]
  assign _GEN_102 = io_cpu_req_valid ? _T_485 : 3'h0; // @[Cache.scala 159:32]
  assign _T_491 = is_dirty == 1'h0; // @[Cache.scala 166:30]
  assign _T_492 = io_nasti_aw_ready & io_nasti_aw_valid; // @[Decoupled.scala 37:37]
  assign _T_493 = io_nasti_ar_ready & io_nasti_ar_valid; // @[Decoupled.scala 37:37]
  assign _GEN_103 = _T_493 ? 3'h6 : state; // @[Cache.scala 169:40]
  assign _GEN_104 = _T_492 ? 3'h3 : _GEN_103; // @[Cache.scala 167:34]
  assign _GEN_105 = hit ? _GEN_102 : _GEN_104; // @[Cache.scala 158:17]
  assign _GEN_106 = hit ? 1'h0 : is_dirty; // @[Cache.scala 158:17]
  assign _GEN_107 = hit ? 1'h0 : _T_491; // @[Cache.scala 158:17]
  assign _T_494 = 3'h2 == state; // @[Conditional.scala 37:30]
  assign _T_496 = _T_130 | io_cpu_abort; // @[Cache.scala 175:32]
  assign _GEN_110 = _T_496 ? 3'h0 : _GEN_104; // @[Cache.scala 175:49]
  assign _GEN_111 = _T_496 ? 1'h0 : is_dirty; // @[Cache.scala 175:49]
  assign _GEN_112 = _T_496 ? 1'h0 : _T_491; // @[Cache.scala 175:49]
  assign _T_501 = 3'h3 == state; // @[Conditional.scala 37:30]
  assign _GEN_113 = write_wrap_out ? 3'h4 : state; // @[Cache.scala 189:28]
  assign _T_503 = 3'h4 == state; // @[Conditional.scala 37:30]
  assign _T_505 = io_nasti_b_ready & io_nasti_b_valid; // @[Decoupled.scala 37:37]
  assign _GEN_114 = _T_505 ? 3'h5 : state; // @[Cache.scala 195:31]
  assign _T_506 = 3'h5 == state; // @[Conditional.scala 37:30]
  assign _T_509 = 3'h6 == state; // @[Conditional.scala 37:30]
  assign _T_512 = _T_258 ? 3'h2 : 3'h0; // @[Cache.scala 207:21]
  assign _GEN_116 = read_wrap_out ? _T_512 : state; // @[Cache.scala 206:27]
  assign _GEN_117 = _T_509 ? _GEN_116 : state; // @[Conditional.scala 39:67]
  assign _GEN_119 = _T_506 ? _GEN_103 : _GEN_117; // @[Conditional.scala 39:67]
  assign _GEN_121 = _T_503 ? _GEN_114 : _GEN_119; // @[Conditional.scala 39:67]
  assign _GEN_122 = _T_503 ? 1'h0 : _T_506; // @[Conditional.scala 39:67]
  assign _GEN_124 = _T_501 ? _GEN_113 : _GEN_121; // @[Conditional.scala 39:67]
  assign _GEN_125 = _T_501 ? 1'h0 : _T_503; // @[Conditional.scala 39:67]
  assign _GEN_126 = _T_501 ? 1'h0 : _GEN_122; // @[Conditional.scala 39:67]
  assign _GEN_127 = _T_494 ? _GEN_110 : _GEN_124; // @[Conditional.scala 39:67]
  assign _GEN_128 = _T_494 ? _GEN_111 : 1'h0; // @[Conditional.scala 39:67]
  assign _GEN_129 = _T_494 ? _GEN_112 : _GEN_126; // @[Conditional.scala 39:67]
  assign _GEN_130 = _T_494 ? 1'h0 : _T_501; // @[Conditional.scala 39:67]
  assign _GEN_131 = _T_494 ? 1'h0 : _GEN_125; // @[Conditional.scala 39:67]
  assign _GEN_132 = _T_486 ? _GEN_105 : _GEN_127; // @[Conditional.scala 39:67]
  assign _GEN_133 = _T_486 ? _GEN_106 : _GEN_128; // @[Conditional.scala 39:67]
  assign _GEN_134 = _T_486 ? _GEN_107 : _GEN_129; // @[Conditional.scala 39:67]
  assign _GEN_135 = _T_486 ? 1'h0 : _GEN_130; // @[Conditional.scala 39:67]
  assign _GEN_136 = _T_486 ? 1'h0 : _GEN_131; // @[Conditional.scala 39:67]
  assign _GEN_137 = _T_482 ? _GEN_101 : _GEN_132; // @[Conditional.scala 40:58]
  assign _GEN_138 = _T_482 ? 1'h0 : _GEN_133; // @[Conditional.scala 40:58]
  assign _GEN_139 = _T_482 ? 1'h0 : _GEN_134; // @[Conditional.scala 40:58]
  assign _GEN_140 = _T_482 ? 1'h0 : _GEN_135; // @[Conditional.scala 40:58]
  assign _GEN_141 = _T_482 ? 1'h0 : _GEN_136; // @[Conditional.scala 40:58]
  assign _T_422_addr = _T_417[31:0]; // @[nasti.scala 178:18]
  assign _T_445_addr = _T_440[31:0]; // @[nasti.scala 158:18]
  assign io_cpu_resp_valid = _T_262;
  assign io_cpu_resp_bits_data = _GEN_14;
  assign io_nasti_aw_valid = _GEN_138;
  assign io_nasti_aw_bits_addr = _T_445_addr;
  assign io_nasti_w_valid = _GEN_140;
  assign io_nasti_w_bits_data = _GEN_100;
  assign io_nasti_w_bits_last = write_wrap_out;
  assign io_nasti_b_ready = _GEN_141;
  assign io_nasti_ar_valid = _GEN_139;
  assign io_nasti_ar_bits_addr = _T_422_addr;
  assign io_nasti_r_ready = _T_127;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  state = _RAND_0[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {8{$random}};
  v = _RAND_1[255:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {8{$random}};
  d = _RAND_2[255:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_3 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    metaMem_tag[initvar] = _RAND_3[19:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{$random}};
  metaMem_tag_rmeta_addr_pipe_0 = _RAND_4[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_5 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_0_0[initvar] = _RAND_5[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{$random}};
  dataMem_0_0__T_150_addr_pipe_0 = _RAND_6[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_7 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_0_1[initvar] = _RAND_7[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_8 = {1{$random}};
  dataMem_0_1__T_150_addr_pipe_0 = _RAND_8[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_9 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_0_2[initvar] = _RAND_9[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_10 = {1{$random}};
  dataMem_0_2__T_150_addr_pipe_0 = _RAND_10[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_11 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_0_3[initvar] = _RAND_11[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_12 = {1{$random}};
  dataMem_0_3__T_150_addr_pipe_0 = _RAND_12[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_13 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_1_0[initvar] = _RAND_13[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_14 = {1{$random}};
  dataMem_1_0__T_170_addr_pipe_0 = _RAND_14[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_15 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_1_1[initvar] = _RAND_15[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_16 = {1{$random}};
  dataMem_1_1__T_170_addr_pipe_0 = _RAND_16[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_17 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_1_2[initvar] = _RAND_17[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_18 = {1{$random}};
  dataMem_1_2__T_170_addr_pipe_0 = _RAND_18[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_19 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_1_3[initvar] = _RAND_19[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_20 = {1{$random}};
  dataMem_1_3__T_170_addr_pipe_0 = _RAND_20[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_21 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_2_0[initvar] = _RAND_21[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_22 = {1{$random}};
  dataMem_2_0__T_190_addr_pipe_0 = _RAND_22[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_23 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_2_1[initvar] = _RAND_23[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_24 = {1{$random}};
  dataMem_2_1__T_190_addr_pipe_0 = _RAND_24[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_25 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_2_2[initvar] = _RAND_25[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_26 = {1{$random}};
  dataMem_2_2__T_190_addr_pipe_0 = _RAND_26[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_27 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_2_3[initvar] = _RAND_27[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_28 = {1{$random}};
  dataMem_2_3__T_190_addr_pipe_0 = _RAND_28[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_29 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_3_0[initvar] = _RAND_29[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_30 = {1{$random}};
  dataMem_3_0__T_210_addr_pipe_0 = _RAND_30[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_31 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_3_1[initvar] = _RAND_31[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_32 = {1{$random}};
  dataMem_3_1__T_210_addr_pipe_0 = _RAND_32[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_33 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_3_2[initvar] = _RAND_33[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_34 = {1{$random}};
  dataMem_3_2__T_210_addr_pipe_0 = _RAND_34[7:0];
  `endif // RANDOMIZE_REG_INIT
  _RAND_35 = {1{$random}};
  `ifdef RANDOMIZE_MEM_INIT
  for (initvar = 0; initvar < 256; initvar = initvar+1)
    dataMem_3_3[initvar] = _RAND_35[7:0];
  `endif // RANDOMIZE_MEM_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_36 = {1{$random}};
  dataMem_3_3__T_210_addr_pipe_0 = _RAND_36[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_37 = {1{$random}};
  addr_reg = _RAND_37[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_38 = {1{$random}};
  cpu_data = _RAND_38[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_39 = {1{$random}};
  cpu_mask = _RAND_39[3:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_40 = {1{$random}};
  value = _RAND_40[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_41 = {1{$random}};
  value_1 = _RAND_41[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_42 = {1{$random}};
  is_alloc_reg = _RAND_42[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_43 = {1{$random}};
  ren_reg = _RAND_43[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_44 = {4{$random}};
  rdata_buf = _RAND_44[127:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_45 = {2{$random}};
  refill_buf_0 = _RAND_45[63:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_46 = {2{$random}};
  refill_buf_1 = _RAND_46[63:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      state <= 3'h0;
    end else begin
      if (_T_482) begin
        if (io_cpu_req_valid) begin
          if (_T_484) begin
            state <= 3'h2;
          end else begin
            state <= 3'h1;
          end
        end
      end else begin
        if (_T_486) begin
          if (hit) begin
            if (io_cpu_req_valid) begin
              if (_T_484) begin
                state <= 3'h2;
              end else begin
                state <= 3'h1;
              end
            end else begin
              state <= 3'h0;
            end
          end else begin
            if (_T_492) begin
              state <= 3'h3;
            end else begin
              if (_T_493) begin
                state <= 3'h6;
              end
            end
          end
        end else begin
          if (_T_494) begin
            if (_T_496) begin
              state <= 3'h0;
            end else begin
              if (_T_492) begin
                state <= 3'h3;
              end else begin
                if (_T_493) begin
                  state <= 3'h6;
                end
              end
            end
          end else begin
            if (_T_501) begin
              if (write_wrap_out) begin
                state <= 3'h4;
              end
            end else begin
              if (_T_503) begin
                if (_T_505) begin
                  state <= 3'h5;
                end
              end else begin
                if (_T_506) begin
                  if (_T_493) begin
                    state <= 3'h6;
                  end
                end else begin
                  if (_T_509) begin
                    if (read_wrap_out) begin
                      if (_T_258) begin
                        state <= 3'h2;
                      end else begin
                        state <= 3'h0;
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    if (reset) begin
      v <= 256'h0;
    end else begin
      if (wen) begin
        v <= _T_279;
      end
    end
    if (reset) begin
      d <= 256'h0;
    end else begin
      if (wen) begin
        if (_T_265) begin
          d <= _T_288;
        end else begin
          d <= _T_291;
        end
      end
    end
    if(metaMem_tag__T_293_en & metaMem_tag__T_293_mask) begin
      metaMem_tag[metaMem_tag__T_293_addr] <= metaMem_tag__T_293_data; // @[Cache.scala 63:24]
    end
    if (_GEN_142) begin
      metaMem_tag_rmeta_addr_pipe_0 <= idx;
    end
    if(dataMem_0_0__T_312_en & dataMem_0_0__T_312_mask) begin
      dataMem_0_0[dataMem_0_0__T_312_addr] <= dataMem_0_0__T_312_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_0_0__T_150_addr_pipe_0 <= idx;
    end
    if(dataMem_0_1__T_312_en & dataMem_0_1__T_312_mask) begin
      dataMem_0_1[dataMem_0_1__T_312_addr] <= dataMem_0_1__T_312_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_0_1__T_150_addr_pipe_0 <= idx;
    end
    if(dataMem_0_2__T_312_en & dataMem_0_2__T_312_mask) begin
      dataMem_0_2[dataMem_0_2__T_312_addr] <= dataMem_0_2__T_312_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_0_2__T_150_addr_pipe_0 <= idx;
    end
    if(dataMem_0_3__T_312_en & dataMem_0_3__T_312_mask) begin
      dataMem_0_3[dataMem_0_3__T_312_addr] <= dataMem_0_3__T_312_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_0_3__T_150_addr_pipe_0 <= idx;
    end
    if(dataMem_1_0__T_342_en & dataMem_1_0__T_342_mask) begin
      dataMem_1_0[dataMem_1_0__T_342_addr] <= dataMem_1_0__T_342_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_1_0__T_170_addr_pipe_0 <= idx;
    end
    if(dataMem_1_1__T_342_en & dataMem_1_1__T_342_mask) begin
      dataMem_1_1[dataMem_1_1__T_342_addr] <= dataMem_1_1__T_342_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_1_1__T_170_addr_pipe_0 <= idx;
    end
    if(dataMem_1_2__T_342_en & dataMem_1_2__T_342_mask) begin
      dataMem_1_2[dataMem_1_2__T_342_addr] <= dataMem_1_2__T_342_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_1_2__T_170_addr_pipe_0 <= idx;
    end
    if(dataMem_1_3__T_342_en & dataMem_1_3__T_342_mask) begin
      dataMem_1_3[dataMem_1_3__T_342_addr] <= dataMem_1_3__T_342_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_1_3__T_170_addr_pipe_0 <= idx;
    end
    if(dataMem_2_0__T_372_en & dataMem_2_0__T_372_mask) begin
      dataMem_2_0[dataMem_2_0__T_372_addr] <= dataMem_2_0__T_372_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_2_0__T_190_addr_pipe_0 <= idx;
    end
    if(dataMem_2_1__T_372_en & dataMem_2_1__T_372_mask) begin
      dataMem_2_1[dataMem_2_1__T_372_addr] <= dataMem_2_1__T_372_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_2_1__T_190_addr_pipe_0 <= idx;
    end
    if(dataMem_2_2__T_372_en & dataMem_2_2__T_372_mask) begin
      dataMem_2_2[dataMem_2_2__T_372_addr] <= dataMem_2_2__T_372_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_2_2__T_190_addr_pipe_0 <= idx;
    end
    if(dataMem_2_3__T_372_en & dataMem_2_3__T_372_mask) begin
      dataMem_2_3[dataMem_2_3__T_372_addr] <= dataMem_2_3__T_372_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_2_3__T_190_addr_pipe_0 <= idx;
    end
    if(dataMem_3_0__T_402_en & dataMem_3_0__T_402_mask) begin
      dataMem_3_0[dataMem_3_0__T_402_addr] <= dataMem_3_0__T_402_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_3_0__T_210_addr_pipe_0 <= idx;
    end
    if(dataMem_3_1__T_402_en & dataMem_3_1__T_402_mask) begin
      dataMem_3_1[dataMem_3_1__T_402_addr] <= dataMem_3_1__T_402_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_3_1__T_210_addr_pipe_0 <= idx;
    end
    if(dataMem_3_2__T_402_en & dataMem_3_2__T_402_mask) begin
      dataMem_3_2[dataMem_3_2__T_402_addr] <= dataMem_3_2__T_402_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_3_2__T_210_addr_pipe_0 <= idx;
    end
    if(dataMem_3_3__T_402_en & dataMem_3_3__T_402_mask) begin
      dataMem_3_3[dataMem_3_3__T_402_addr] <= dataMem_3_3__T_402_data; // @[Cache.scala 64:41]
    end
    if (_GEN_142) begin
      dataMem_3_3__T_210_addr_pipe_0 <= idx;
    end
    if (io_cpu_resp_valid) begin
      addr_reg <= io_cpu_req_bits_addr;
    end
    if (io_cpu_resp_valid) begin
      cpu_data <= io_cpu_req_bits_data;
    end
    if (io_cpu_resp_valid) begin
      cpu_mask <= io_cpu_req_bits_mask;
    end
    if (reset) begin
      value <= 1'h0;
    end else begin
      if (_T_111) begin
        value <= _T_118;
      end
    end
    if (reset) begin
      value_1 <= 1'h0;
    end else begin
      if (_T_119) begin
        value_1 <= _T_126;
      end
    end
    is_alloc_reg <= is_alloc;
    ren_reg <= ren;
    if (ren_reg) begin
      rdata_buf <= rdata;
    end
    if (_T_111) begin
      if (1'h0 == value) begin
        refill_buf_0 <= io_nasti_r_bits_data;
      end
    end
    if (_T_111) begin
      if (value) begin
        refill_buf_1 <= io_nasti_r_bits_data;
      end
    end
  end
endmodule
module MemArbiter(
  input         clock,
  input         reset,
  output        io_icache_ar_ready,
  input         io_icache_ar_valid,
  input  [31:0] io_icache_ar_bits_addr,
  input         io_icache_r_ready,
  output        io_icache_r_valid,
  output [63:0] io_icache_r_bits_data,
  output        io_dcache_aw_ready,
  input         io_dcache_aw_valid,
  input  [31:0] io_dcache_aw_bits_addr,
  output        io_dcache_w_ready,
  input         io_dcache_w_valid,
  input  [63:0] io_dcache_w_bits_data,
  input         io_dcache_w_bits_last,
  input         io_dcache_b_ready,
  output        io_dcache_b_valid,
  output        io_dcache_ar_ready,
  input         io_dcache_ar_valid,
  input  [31:0] io_dcache_ar_bits_addr,
  input         io_dcache_r_ready,
  output        io_dcache_r_valid,
  output [63:0] io_dcache_r_bits_data,
  input         io_nasti_aw_ready,
  output        io_nasti_aw_valid,
  output [31:0] io_nasti_aw_bits_addr,
  input         io_nasti_w_ready,
  output        io_nasti_w_valid,
  output [63:0] io_nasti_w_bits_data,
  output        io_nasti_w_bits_last,
  output        io_nasti_b_ready,
  input         io_nasti_b_valid,
  input         io_nasti_ar_ready,
  output        io_nasti_ar_valid,
  output [31:0] io_nasti_ar_bits_addr,
  output        io_nasti_r_ready,
  input         io_nasti_r_valid,
  input  [63:0] io_nasti_r_bits_data,
  input         io_nasti_r_bits_last
);
  reg [2:0] state; // @[Tile.scala 20:22]
  reg [31:0] _RAND_0;
  wire  _T_220; // @[Tile.scala 24:52]
  wire  _T_221; // @[Tile.scala 24:43]
  wire  _T_223; // @[Tile.scala 25:43]
  wire  _T_224; // @[Tile.scala 30:50]
  wire  _T_225; // @[Tile.scala 30:41]
  wire  _T_227; // @[Tile.scala 31:41]
  wire  _T_228; // @[Tile.scala 36:50]
  wire  _T_229; // @[Tile.scala 36:41]
  wire  _T_231; // @[Tile.scala 37:41]
  wire [31:0] _T_233; // @[Tile.scala 43:8]
  wire  _T_249; // @[Tile.scala 46:44]
  wire  _T_251; // @[Tile.scala 47:5]
  wire  _T_252; // @[Tile.scala 46:67]
  wire  _T_254; // @[Tile.scala 47:24]
  wire  _T_257; // @[Tile.scala 48:43]
  wire  _T_259; // @[Tile.scala 48:65]
  wire  _T_261; // @[Tile.scala 49:47]
  wire  _T_262; // @[Tile.scala 49:44]
  wire  _T_263; // @[Tile.scala 54:50]
  wire  _T_264; // @[Tile.scala 54:41]
  wire  _T_265; // @[Tile.scala 55:50]
  wire  _T_266; // @[Tile.scala 55:41]
  wire  _T_268; // @[Tile.scala 56:41]
  wire  _T_270; // @[Tile.scala 57:41]
  wire  _T_271; // @[Tile.scala 56:68]
  wire  _T_272; // @[Conditional.scala 37:30]
  wire  _T_273; // @[Decoupled.scala 37:37]
  wire  _T_274; // @[Decoupled.scala 37:37]
  wire  _T_275; // @[Decoupled.scala 37:37]
  wire [2:0] _GEN_0; // @[Tile.scala 65:39]
  wire [2:0] _GEN_1; // @[Tile.scala 63:39]
  wire [2:0] _GEN_2; // @[Tile.scala 61:33]
  wire  _T_276; // @[Conditional.scala 37:30]
  wire  _T_277; // @[Decoupled.scala 37:37]
  wire  _T_278; // @[Tile.scala 70:30]
  wire [2:0] _GEN_3; // @[Tile.scala 70:55]
  wire  _T_279; // @[Conditional.scala 37:30]
  wire  _T_282; // @[Conditional.scala 37:30]
  wire  _T_283; // @[Decoupled.scala 37:37]
  wire  _T_284; // @[Tile.scala 80:31]
  wire [2:0] _GEN_5; // @[Tile.scala 80:57]
  wire  _T_285; // @[Conditional.scala 37:30]
  wire  _T_286; // @[Decoupled.scala 37:37]
  wire [2:0] _GEN_6; // @[Tile.scala 85:31]
  wire [2:0] _GEN_7; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_8; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_9; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_10; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_11; // @[Conditional.scala 40:58]
  assign _T_220 = state == 3'h0; // @[Tile.scala 24:52]
  assign _T_221 = io_dcache_aw_valid & _T_220; // @[Tile.scala 24:43]
  assign _T_223 = io_nasti_aw_ready & _T_220; // @[Tile.scala 25:43]
  assign _T_224 = state == 3'h3; // @[Tile.scala 30:50]
  assign _T_225 = io_dcache_w_valid & _T_224; // @[Tile.scala 30:41]
  assign _T_227 = io_nasti_w_ready & _T_224; // @[Tile.scala 31:41]
  assign _T_228 = state == 3'h4; // @[Tile.scala 36:50]
  assign _T_229 = io_nasti_b_valid & _T_228; // @[Tile.scala 36:41]
  assign _T_231 = io_dcache_b_ready & _T_228; // @[Tile.scala 37:41]
  assign _T_233 = io_dcache_ar_valid ? io_dcache_ar_bits_addr : io_icache_ar_bits_addr; // @[Tile.scala 43:8]
  assign _T_249 = io_icache_ar_valid | io_dcache_ar_valid; // @[Tile.scala 46:44]
  assign _T_251 = io_nasti_aw_valid == 1'h0; // @[Tile.scala 47:5]
  assign _T_252 = _T_249 & _T_251; // @[Tile.scala 46:67]
  assign _T_254 = _T_252 & _T_220; // @[Tile.scala 47:24]
  assign _T_257 = io_nasti_ar_ready & _T_251; // @[Tile.scala 48:43]
  assign _T_259 = _T_257 & _T_220; // @[Tile.scala 48:65]
  assign _T_261 = io_dcache_ar_valid == 1'h0; // @[Tile.scala 49:47]
  assign _T_262 = io_dcache_ar_ready & _T_261; // @[Tile.scala 49:44]
  assign _T_263 = state == 3'h1; // @[Tile.scala 54:50]
  assign _T_264 = io_nasti_r_valid & _T_263; // @[Tile.scala 54:41]
  assign _T_265 = state == 3'h2; // @[Tile.scala 55:50]
  assign _T_266 = io_nasti_r_valid & _T_265; // @[Tile.scala 55:41]
  assign _T_268 = io_icache_r_ready & _T_263; // @[Tile.scala 56:41]
  assign _T_270 = io_dcache_r_ready & _T_265; // @[Tile.scala 57:41]
  assign _T_271 = _T_268 | _T_270; // @[Tile.scala 56:68]
  assign _T_272 = 3'h0 == state; // @[Conditional.scala 37:30]
  assign _T_273 = io_dcache_aw_ready & io_dcache_aw_valid; // @[Decoupled.scala 37:37]
  assign _T_274 = io_dcache_ar_ready & io_dcache_ar_valid; // @[Decoupled.scala 37:37]
  assign _T_275 = io_icache_ar_ready & io_icache_ar_valid; // @[Decoupled.scala 37:37]
  assign _GEN_0 = _T_275 ? 3'h1 : state; // @[Tile.scala 65:39]
  assign _GEN_1 = _T_274 ? 3'h2 : _GEN_0; // @[Tile.scala 63:39]
  assign _GEN_2 = _T_273 ? 3'h3 : _GEN_1; // @[Tile.scala 61:33]
  assign _T_276 = 3'h1 == state; // @[Conditional.scala 37:30]
  assign _T_277 = io_nasti_r_ready & io_nasti_r_valid; // @[Decoupled.scala 37:37]
  assign _T_278 = _T_277 & io_nasti_r_bits_last; // @[Tile.scala 70:30]
  assign _GEN_3 = _T_278 ? 3'h0 : state; // @[Tile.scala 70:55]
  assign _T_279 = 3'h2 == state; // @[Conditional.scala 37:30]
  assign _T_282 = 3'h3 == state; // @[Conditional.scala 37:30]
  assign _T_283 = io_dcache_w_ready & io_dcache_w_valid; // @[Decoupled.scala 37:37]
  assign _T_284 = _T_283 & io_dcache_w_bits_last; // @[Tile.scala 80:31]
  assign _GEN_5 = _T_284 ? 3'h4 : state; // @[Tile.scala 80:57]
  assign _T_285 = 3'h4 == state; // @[Conditional.scala 37:30]
  assign _T_286 = io_nasti_b_ready & io_nasti_b_valid; // @[Decoupled.scala 37:37]
  assign _GEN_6 = _T_286 ? 3'h0 : state; // @[Tile.scala 85:31]
  assign _GEN_7 = _T_285 ? _GEN_6 : state; // @[Conditional.scala 39:67]
  assign _GEN_8 = _T_282 ? _GEN_5 : _GEN_7; // @[Conditional.scala 39:67]
  assign _GEN_9 = _T_279 ? _GEN_3 : _GEN_8; // @[Conditional.scala 39:67]
  assign _GEN_10 = _T_276 ? _GEN_3 : _GEN_9; // @[Conditional.scala 39:67]
  assign _GEN_11 = _T_272 ? _GEN_2 : _GEN_10; // @[Conditional.scala 40:58]
  assign io_icache_ar_ready = _T_262;
  assign io_icache_r_valid = _T_264;
  assign io_icache_r_bits_data = io_nasti_r_bits_data;
  assign io_dcache_aw_ready = _T_223;
  assign io_dcache_w_ready = _T_227;
  assign io_dcache_b_valid = _T_229;
  assign io_dcache_ar_ready = _T_259;
  assign io_dcache_r_valid = _T_266;
  assign io_dcache_r_bits_data = io_nasti_r_bits_data;
  assign io_nasti_aw_valid = _T_221;
  assign io_nasti_aw_bits_addr = io_dcache_aw_bits_addr;
  assign io_nasti_w_valid = _T_225;
  assign io_nasti_w_bits_data = io_dcache_w_bits_data;
  assign io_nasti_w_bits_last = io_dcache_w_bits_last;
  assign io_nasti_b_ready = _T_231;
  assign io_nasti_ar_valid = _T_254;
  assign io_nasti_ar_bits_addr = _T_233;
  assign io_nasti_r_ready = _T_271;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  state = _RAND_0[2:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      state <= 3'h0;
    end else begin
      if (_T_272) begin
        if (_T_273) begin
          state <= 3'h3;
        end else begin
          if (_T_274) begin
            state <= 3'h2;
          end else begin
            if (_T_275) begin
              state <= 3'h1;
            end
          end
        end
      end else begin
        if (_T_276) begin
          if (_T_278) begin
            state <= 3'h0;
          end
        end else begin
          if (_T_279) begin
            if (_T_278) begin
              state <= 3'h0;
            end
          end else begin
            if (_T_282) begin
              if (_T_284) begin
                state <= 3'h4;
              end
            end else begin
              if (_T_285) begin
                if (_T_286) begin
                  state <= 3'h0;
                end
              end
            end
          end
        end
      end
    end
  end
endmodule
module Selector(
  input         clock,
  input         reset,
  input         io_cpu_abort,
  input         io_cpu_req_valid,
  input  [31:0] io_cpu_req_bits_addr,
  input  [31:0] io_cpu_req_bits_data,
  input  [3:0]  io_cpu_req_bits_mask,
  output        io_cpu_resp_valid,
  output [31:0] io_cpu_resp_bits_data,
  output        io_dcache_abort,
  output        io_dcache_req_valid,
  output [31:0] io_dcache_req_bits_addr,
  output [31:0] io_dcache_req_bits_data,
  output [3:0]  io_dcache_req_bits_mask,
  input         io_dcache_resp_valid,
  input  [31:0] io_dcache_resp_bits_data,
  output        io_devices_req_valid,
  output [31:0] io_devices_req_bits_addr,
  output [31:0] io_devices_req_bits_data,
  input         io_devices_resp_valid,
  input  [31:0] io_devices_resp_bits_data
);
  reg [31:0] addr; // @[MMIO.scala 19:21]
  reg [31:0] _RAND_0;
  wire [31:0] _GEN_0; // @[MMIO.scala 21:27]
  wire [31:0] _T_83; // @[MMIO.scala 29:48]
  wire  _T_84; // @[MMIO.scala 29:48]
  wire  _T_86; // @[MMIO.scala 29:48]
  wire  _T_87; // @[MMIO.scala 29:70]
  wire  _T_92; // @[MMIO.scala 34:71]
  wire [31:0] _T_95; // @[MMIO.scala 37:11]
  wire  _T_96; // @[MMIO.scala 37:11]
  wire [31:0] _T_97; // @[Mux.scala 61:16]
  wire  _T_102; // @[Mux.scala 61:16]
  assign _GEN_0 = io_cpu_req_valid ? io_cpu_req_bits_addr : addr; // @[MMIO.scala 21:27]
  assign _T_83 = io_cpu_req_bits_addr & 32'hf0000000; // @[MMIO.scala 29:48]
  assign _T_84 = 32'h10000000 == _T_83; // @[MMIO.scala 29:48]
  assign _T_86 = _T_84 == 1'h0; // @[MMIO.scala 29:48]
  assign _T_87 = _T_86 & io_cpu_req_valid; // @[MMIO.scala 29:70]
  assign _T_92 = _T_84 & io_cpu_req_valid; // @[MMIO.scala 34:71]
  assign _T_95 = addr & 32'hf0000000; // @[MMIO.scala 37:11]
  assign _T_96 = 32'h10000000 == _T_95; // @[MMIO.scala 37:11]
  assign _T_97 = _T_96 ? io_devices_resp_bits_data : io_dcache_resp_bits_data; // @[Mux.scala 61:16]
  assign _T_102 = _T_96 ? io_devices_resp_valid : io_dcache_resp_valid; // @[Mux.scala 61:16]
  assign io_cpu_resp_valid = _T_102;
  assign io_cpu_resp_bits_data = _T_97;
  assign io_dcache_abort = io_cpu_abort;
  assign io_dcache_req_valid = _T_87;
  assign io_dcache_req_bits_addr = io_cpu_req_bits_addr;
  assign io_dcache_req_bits_data = io_cpu_req_bits_data;
  assign io_dcache_req_bits_mask = io_cpu_req_bits_mask;
  assign io_devices_req_valid = _T_92;
  assign io_devices_req_bits_addr = io_cpu_req_bits_addr;
  assign io_devices_req_bits_data = io_cpu_req_bits_data;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  addr = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      addr <= 32'h0;
    end else begin
      if (io_cpu_req_valid) begin
        addr <= io_cpu_req_bits_addr;
      end
    end
  end
endmodule
module RegMapper(
  input         clock,
  input         io_selector_req_valid,
  input  [31:0] io_selector_req_bits_addr,
  input  [31:0] io_selector_req_bits_data,
  output        io_selector_resp_valid,
  output [31:0] io_selector_resp_bits_data,
  output        io_uart_req_valid,
  output [31:0] io_uart_req_bits_addr,
  output [31:0] io_uart_req_bits_data,
  input         io_uart_resp_valid,
  input  [31:0] io_uart_resp_bits_data,
  output        io_ledController_req_valid,
  output [31:0] io_ledController_req_bits_data
);
  reg [31:0] addr; // @[Reg.scala 11:16]
  reg [31:0] _RAND_0;
  wire [31:0] _GEN_0; // @[Reg.scala 12:19]
  wire [31:0] _T_82; // @[MMIO.scala 64:51]
  wire  _T_83; // @[MMIO.scala 64:51]
  wire  _T_84; // @[MMIO.scala 64:71]
  wire  _T_88; // @[MMIO.scala 66:60]
  wire  _T_89; // @[MMIO.scala 66:79]
  wire [31:0] _T_93; // @[MMIO.scala 70:11]
  wire  _T_94; // @[MMIO.scala 70:11]
  wire  _T_98; // @[MMIO.scala 71:11]
  wire [31:0] respData; // @[Mux.scala 61:16]
  wire  respValid; // @[Mux.scala 61:16]
  assign _GEN_0 = io_selector_req_valid ? io_selector_req_bits_addr : addr; // @[Reg.scala 12:19]
  assign _T_82 = io_selector_req_bits_addr & 32'hfffffff0; // @[MMIO.scala 64:51]
  assign _T_83 = 32'h10000000 == _T_82; // @[MMIO.scala 64:51]
  assign _T_84 = _T_83 & io_selector_req_valid; // @[MMIO.scala 64:71]
  assign _T_88 = 32'h10010000 == io_selector_req_bits_addr; // @[MMIO.scala 66:60]
  assign _T_89 = _T_88 & io_selector_req_valid; // @[MMIO.scala 66:79]
  assign _T_93 = addr & 32'hfffffff0; // @[MMIO.scala 70:11]
  assign _T_94 = 32'h10000000 == _T_93; // @[MMIO.scala 70:11]
  assign _T_98 = 32'h10010000 == addr; // @[MMIO.scala 71:11]
  assign respData = _T_94 ? io_uart_resp_bits_data : 32'h0; // @[Mux.scala 61:16]
  assign respValid = _T_94 ? io_uart_resp_valid : _T_98; // @[Mux.scala 61:16]
  assign io_selector_resp_valid = respValid;
  assign io_selector_resp_bits_data = respData;
  assign io_uart_req_valid = _T_84;
  assign io_uart_req_bits_addr = io_selector_req_bits_addr;
  assign io_uart_req_bits_data = io_selector_req_bits_data;
  assign io_ledController_req_valid = _T_89;
  assign io_ledController_req_bits_data = io_selector_req_bits_data;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  addr = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (io_selector_req_valid) begin
      addr <= io_selector_req_bits_addr;
    end
  end
endmodule
module MMIO(
  input         clock,
  input         reset,
  input         io_cpu_abort,
  input         io_cpu_req_valid,
  input  [31:0] io_cpu_req_bits_addr,
  input  [31:0] io_cpu_req_bits_data,
  input  [3:0]  io_cpu_req_bits_mask,
  output        io_cpu_resp_valid,
  output [31:0] io_cpu_resp_bits_data,
  output        io_dcache_abort,
  output        io_dcache_req_valid,
  output [31:0] io_dcache_req_bits_addr,
  output [31:0] io_dcache_req_bits_data,
  output [3:0]  io_dcache_req_bits_mask,
  input         io_dcache_resp_valid,
  input  [31:0] io_dcache_resp_bits_data,
  output        io_uart_req_valid,
  output [31:0] io_uart_req_bits_addr,
  output [31:0] io_uart_req_bits_data,
  input         io_uart_resp_valid,
  input  [31:0] io_uart_resp_bits_data,
  output        io_ledController_req_valid,
  output [31:0] io_ledController_req_bits_data
);
  wire  selector_clock; // @[MMIO.scala 94:24]
  wire  selector_reset; // @[MMIO.scala 94:24]
  wire  selector_io_cpu_abort; // @[MMIO.scala 94:24]
  wire  selector_io_cpu_req_valid; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_cpu_req_bits_addr; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_cpu_req_bits_data; // @[MMIO.scala 94:24]
  wire [3:0] selector_io_cpu_req_bits_mask; // @[MMIO.scala 94:24]
  wire  selector_io_cpu_resp_valid; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_cpu_resp_bits_data; // @[MMIO.scala 94:24]
  wire  selector_io_dcache_abort; // @[MMIO.scala 94:24]
  wire  selector_io_dcache_req_valid; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_dcache_req_bits_addr; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_dcache_req_bits_data; // @[MMIO.scala 94:24]
  wire [3:0] selector_io_dcache_req_bits_mask; // @[MMIO.scala 94:24]
  wire  selector_io_dcache_resp_valid; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_dcache_resp_bits_data; // @[MMIO.scala 94:24]
  wire  selector_io_devices_req_valid; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_devices_req_bits_addr; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_devices_req_bits_data; // @[MMIO.scala 94:24]
  wire  selector_io_devices_resp_valid; // @[MMIO.scala 94:24]
  wire [31:0] selector_io_devices_resp_bits_data; // @[MMIO.scala 94:24]
  wire  regMapper_clock; // @[MMIO.scala 95:25]
  wire  regMapper_io_selector_req_valid; // @[MMIO.scala 95:25]
  wire [31:0] regMapper_io_selector_req_bits_addr; // @[MMIO.scala 95:25]
  wire [31:0] regMapper_io_selector_req_bits_data; // @[MMIO.scala 95:25]
  wire  regMapper_io_selector_resp_valid; // @[MMIO.scala 95:25]
  wire [31:0] regMapper_io_selector_resp_bits_data; // @[MMIO.scala 95:25]
  wire  regMapper_io_uart_req_valid; // @[MMIO.scala 95:25]
  wire [31:0] regMapper_io_uart_req_bits_addr; // @[MMIO.scala 95:25]
  wire [31:0] regMapper_io_uart_req_bits_data; // @[MMIO.scala 95:25]
  wire  regMapper_io_uart_resp_valid; // @[MMIO.scala 95:25]
  wire [31:0] regMapper_io_uart_resp_bits_data; // @[MMIO.scala 95:25]
  wire  regMapper_io_ledController_req_valid; // @[MMIO.scala 95:25]
  wire [31:0] regMapper_io_ledController_req_bits_data; // @[MMIO.scala 95:25]
  Selector selector ( // @[MMIO.scala 94:24]
    .clock(selector_clock),
    .reset(selector_reset),
    .io_cpu_abort(selector_io_cpu_abort),
    .io_cpu_req_valid(selector_io_cpu_req_valid),
    .io_cpu_req_bits_addr(selector_io_cpu_req_bits_addr),
    .io_cpu_req_bits_data(selector_io_cpu_req_bits_data),
    .io_cpu_req_bits_mask(selector_io_cpu_req_bits_mask),
    .io_cpu_resp_valid(selector_io_cpu_resp_valid),
    .io_cpu_resp_bits_data(selector_io_cpu_resp_bits_data),
    .io_dcache_abort(selector_io_dcache_abort),
    .io_dcache_req_valid(selector_io_dcache_req_valid),
    .io_dcache_req_bits_addr(selector_io_dcache_req_bits_addr),
    .io_dcache_req_bits_data(selector_io_dcache_req_bits_data),
    .io_dcache_req_bits_mask(selector_io_dcache_req_bits_mask),
    .io_dcache_resp_valid(selector_io_dcache_resp_valid),
    .io_dcache_resp_bits_data(selector_io_dcache_resp_bits_data),
    .io_devices_req_valid(selector_io_devices_req_valid),
    .io_devices_req_bits_addr(selector_io_devices_req_bits_addr),
    .io_devices_req_bits_data(selector_io_devices_req_bits_data),
    .io_devices_resp_valid(selector_io_devices_resp_valid),
    .io_devices_resp_bits_data(selector_io_devices_resp_bits_data)
  );
  RegMapper regMapper ( // @[MMIO.scala 95:25]
    .clock(regMapper_clock),
    .io_selector_req_valid(regMapper_io_selector_req_valid),
    .io_selector_req_bits_addr(regMapper_io_selector_req_bits_addr),
    .io_selector_req_bits_data(regMapper_io_selector_req_bits_data),
    .io_selector_resp_valid(regMapper_io_selector_resp_valid),
    .io_selector_resp_bits_data(regMapper_io_selector_resp_bits_data),
    .io_uart_req_valid(regMapper_io_uart_req_valid),
    .io_uart_req_bits_addr(regMapper_io_uart_req_bits_addr),
    .io_uart_req_bits_data(regMapper_io_uart_req_bits_data),
    .io_uart_resp_valid(regMapper_io_uart_resp_valid),
    .io_uart_resp_bits_data(regMapper_io_uart_resp_bits_data),
    .io_ledController_req_valid(regMapper_io_ledController_req_valid),
    .io_ledController_req_bits_data(regMapper_io_ledController_req_bits_data)
  );
  assign io_cpu_resp_valid = selector_io_cpu_resp_valid;
  assign io_cpu_resp_bits_data = selector_io_cpu_resp_bits_data;
  assign io_dcache_abort = selector_io_dcache_abort;
  assign io_dcache_req_valid = selector_io_dcache_req_valid;
  assign io_dcache_req_bits_addr = selector_io_dcache_req_bits_addr;
  assign io_dcache_req_bits_data = selector_io_dcache_req_bits_data;
  assign io_dcache_req_bits_mask = selector_io_dcache_req_bits_mask;
  assign io_uart_req_valid = regMapper_io_uart_req_valid;
  assign io_uart_req_bits_addr = regMapper_io_uart_req_bits_addr;
  assign io_uart_req_bits_data = regMapper_io_uart_req_bits_data;
  assign io_ledController_req_valid = regMapper_io_ledController_req_valid;
  assign io_ledController_req_bits_data = regMapper_io_ledController_req_bits_data;
  assign selector_clock = clock;
  assign selector_reset = reset;
  assign selector_io_cpu_abort = io_cpu_abort;
  assign selector_io_cpu_req_valid = io_cpu_req_valid;
  assign selector_io_cpu_req_bits_addr = io_cpu_req_bits_addr;
  assign selector_io_cpu_req_bits_data = io_cpu_req_bits_data;
  assign selector_io_cpu_req_bits_mask = io_cpu_req_bits_mask;
  assign selector_io_dcache_resp_valid = io_dcache_resp_valid;
  assign selector_io_dcache_resp_bits_data = io_dcache_resp_bits_data;
  assign selector_io_devices_resp_valid = regMapper_io_selector_resp_valid;
  assign selector_io_devices_resp_bits_data = regMapper_io_selector_resp_bits_data;
  assign regMapper_clock = clock;
  assign regMapper_io_selector_req_valid = selector_io_devices_req_valid;
  assign regMapper_io_selector_req_bits_addr = selector_io_devices_req_bits_addr;
  assign regMapper_io_selector_req_bits_data = selector_io_devices_req_bits_data;
  assign regMapper_io_uart_resp_valid = io_uart_resp_valid;
  assign regMapper_io_uart_resp_bits_data = io_uart_resp_bits_data;
endmodule
module Tx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
  reg  state; // @[UART.scala 31:22]
  reg [31:0] _RAND_0;
  reg [10:0] shiftReg; // @[UART.scala 35:25]
  reg [31:0] _RAND_1;
  reg [11:0] value; // @[Counter.scala 26:33]
  reg [31:0] _RAND_2;
  reg [3:0] value_1; // @[Counter.scala 26:33]
  reg [31:0] _RAND_3;
  wire  _T_28; // @[Counter.scala 34:24]
  wire [12:0] _T_30; // @[Counter.scala 35:22]
  wire [11:0] _T_31; // @[Counter.scala 35:22]
  wire [11:0] _GEN_0; // @[Counter.scala 37:21]
  wire [11:0] _GEN_1; // @[Counter.scala 63:17]
  wire  baud_wrap_out; // @[Counter.scala 64:20]
  wire  _T_36; // @[Counter.scala 34:24]
  wire [4:0] _T_38; // @[Counter.scala 35:22]
  wire [3:0] _T_39; // @[Counter.scala 35:22]
  wire [3:0] _GEN_2; // @[Counter.scala 37:21]
  wire [3:0] _GEN_3; // @[Counter.scala 63:17]
  wire  bit_wrap_out; // @[Counter.scala 64:20]
  wire  _T_41; // @[UART.scala 42:29]
  wire  _T_42; // @[UART.scala 43:21]
  wire  _T_43; // @[Decoupled.scala 37:37]
  wire [9:0] _T_45; // @[Cat.scala 30:58]
  wire [10:0] _T_47; // @[Cat.scala 30:58]
  wire [10:0] _GEN_4; // @[UART.scala 46:27]
  wire [9:0] _T_49; // @[UART.scala 51:28]
  wire [10:0] _T_52; // @[Cat.scala 30:58]
  wire [10:0] _GEN_5; // @[UART.scala 50:25]
  wire [10:0] _GEN_6; // @[UART.scala 49:26]
  wire  _T_53; // @[Conditional.scala 37:30]
  wire  _GEN_7; // @[UART.scala 59:31]
  wire  _GEN_8; // @[UART.scala 64:26]
  wire  _GEN_9; // @[Conditional.scala 39:67]
  wire  _GEN_10; // @[Conditional.scala 40:58]
  assign _T_28 = value == 12'h878; // @[Counter.scala 34:24]
  assign _T_30 = value + 12'h1; // @[Counter.scala 35:22]
  assign _T_31 = _T_30[11:0]; // @[Counter.scala 35:22]
  assign _GEN_0 = _T_28 ? 12'h0 : _T_31; // @[Counter.scala 37:21]
  assign _GEN_1 = state ? _GEN_0 : value; // @[Counter.scala 63:17]
  assign baud_wrap_out = state & _T_28; // @[Counter.scala 64:20]
  assign _T_36 = value_1 == 4'ha; // @[Counter.scala 34:24]
  assign _T_38 = value_1 + 4'h1; // @[Counter.scala 35:22]
  assign _T_39 = _T_38[3:0]; // @[Counter.scala 35:22]
  assign _GEN_2 = _T_36 ? 4'h0 : _T_39; // @[Counter.scala 37:21]
  assign _GEN_3 = baud_wrap_out ? _GEN_2 : value_1; // @[Counter.scala 63:17]
  assign bit_wrap_out = baud_wrap_out & _T_36; // @[Counter.scala 64:20]
  assign _T_41 = state == 1'h0; // @[UART.scala 42:29]
  assign _T_42 = shiftReg[0]; // @[UART.scala 43:21]
  assign _T_43 = io_channel_ready & io_channel_valid; // @[Decoupled.scala 37:37]
  assign _T_45 = {2'h3,io_channel_bits}; // @[Cat.scala 30:58]
  assign _T_47 = {_T_45,1'h0}; // @[Cat.scala 30:58]
  assign _GEN_4 = _T_43 ? _T_47 : shiftReg; // @[UART.scala 46:27]
  assign _T_49 = shiftReg[10:1]; // @[UART.scala 51:28]
  assign _T_52 = {1'h1,_T_49}; // @[Cat.scala 30:58]
  assign _GEN_5 = baud_wrap_out ? _T_52 : _GEN_4; // @[UART.scala 50:25]
  assign _GEN_6 = state ? _GEN_5 : _GEN_4; // @[UART.scala 49:26]
  assign _T_53 = 1'h0 == state; // @[Conditional.scala 37:30]
  assign _GEN_7 = _T_43 ? 1'h1 : state; // @[UART.scala 59:31]
  assign _GEN_8 = bit_wrap_out ? 1'h0 : state; // @[UART.scala 64:26]
  assign _GEN_9 = state ? _GEN_8 : state; // @[Conditional.scala 39:67]
  assign _GEN_10 = _T_53 ? _GEN_7 : _GEN_9; // @[Conditional.scala 40:58]
  assign io_txd = _T_42;
  assign io_channel_ready = _T_41;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  state = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  shiftReg = _RAND_1[10:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  value = _RAND_2[11:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{$random}};
  value_1 = _RAND_3[3:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      state <= 1'h0;
    end else begin
      if (_T_53) begin
        if (_T_43) begin
          state <= 1'h1;
        end
      end else begin
        if (state) begin
          if (bit_wrap_out) begin
            state <= 1'h0;
          end
        end
      end
    end
    if (reset) begin
      shiftReg <= 11'h7ff;
    end else begin
      if (state) begin
        if (baud_wrap_out) begin
          shiftReg <= _T_52;
        end else begin
          if (_T_43) begin
            shiftReg <= _T_47;
          end
        end
      end else begin
        if (_T_43) begin
          shiftReg <= _T_47;
        end
      end
    end
    if (reset) begin
      value <= 12'h0;
    end else begin
      if (state) begin
        if (_T_28) begin
          value <= 12'h0;
        end else begin
          value <= _T_31;
        end
      end
    end
    if (reset) begin
      value_1 <= 4'h0;
    end else begin
      if (baud_wrap_out) begin
        if (_T_36) begin
          value_1 <= 4'h0;
        end else begin
          value_1 <= _T_39;
        end
      end
    end
  end
endmodule
module Buffer(
  input        clock,
  input        reset,
  output       io_in_ready,
  input        io_in_valid,
  input  [7:0] io_in_bits,
  input        io_out_ready,
  output       io_out_valid,
  output [7:0] io_out_bits
);
  reg  state; // @[UART.scala 78:22]
  reg [31:0] _RAND_0;
  reg [7:0] data; // @[UART.scala 79:21]
  reg [31:0] _RAND_1;
  wire  _T_28; // @[UART.scala 81:24]
  wire  _T_30; // @[Conditional.scala 37:30]
  wire  _T_31; // @[Decoupled.scala 37:37]
  wire [7:0] _GEN_0; // @[UART.scala 87:26]
  wire  _GEN_1; // @[UART.scala 87:26]
  wire  _T_33; // @[Decoupled.scala 37:37]
  wire  _GEN_2; // @[UART.scala 93:27]
  wire  _GEN_3; // @[Conditional.scala 39:67]
  wire [7:0] _GEN_4; // @[Conditional.scala 40:58]
  wire  _GEN_5; // @[Conditional.scala 40:58]
  assign _T_28 = state == 1'h0; // @[UART.scala 81:24]
  assign _T_30 = 1'h0 == state; // @[Conditional.scala 37:30]
  assign _T_31 = io_in_ready & io_in_valid; // @[Decoupled.scala 37:37]
  assign _GEN_0 = _T_31 ? io_in_bits : data; // @[UART.scala 87:26]
  assign _GEN_1 = _T_31 ? 1'h1 : state; // @[UART.scala 87:26]
  assign _T_33 = io_out_ready & io_out_valid; // @[Decoupled.scala 37:37]
  assign _GEN_2 = _T_33 ? 1'h0 : state; // @[UART.scala 93:27]
  assign _GEN_3 = state ? _GEN_2 : state; // @[Conditional.scala 39:67]
  assign _GEN_4 = _T_30 ? _GEN_0 : data; // @[Conditional.scala 40:58]
  assign _GEN_5 = _T_30 ? _GEN_1 : _GEN_3; // @[Conditional.scala 40:58]
  assign io_in_ready = _T_28;
  assign io_out_valid = state;
  assign io_out_bits = data;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  state = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  data = _RAND_1[7:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      state <= 1'h0;
    end else begin
      if (_T_30) begin
        if (_T_31) begin
          state <= 1'h1;
        end
      end else begin
        if (state) begin
          if (_T_33) begin
            state <= 1'h0;
          end
        end
      end
    end
    if (reset) begin
      data <= 8'h0;
    end else begin
      if (_T_30) begin
        if (_T_31) begin
          data <= io_in_bits;
        end
      end
    end
  end
endmodule
module BufferedTx(
  input        clock,
  input        reset,
  output       io_txd,
  output       io_channel_ready,
  input        io_channel_valid,
  input  [7:0] io_channel_bits
);
  wire  tx_clock; // @[UART.scala 105:18]
  wire  tx_reset; // @[UART.scala 105:18]
  wire  tx_io_txd; // @[UART.scala 105:18]
  wire  tx_io_channel_ready; // @[UART.scala 105:18]
  wire  tx_io_channel_valid; // @[UART.scala 105:18]
  wire [7:0] tx_io_channel_bits; // @[UART.scala 105:18]
  wire  buf$_clock; // @[UART.scala 106:19]
  wire  buf$_reset; // @[UART.scala 106:19]
  wire  buf$_io_in_ready; // @[UART.scala 106:19]
  wire  buf$_io_in_valid; // @[UART.scala 106:19]
  wire [7:0] buf$_io_in_bits; // @[UART.scala 106:19]
  wire  buf$_io_out_ready; // @[UART.scala 106:19]
  wire  buf$_io_out_valid; // @[UART.scala 106:19]
  wire [7:0] buf$_io_out_bits; // @[UART.scala 106:19]
  Tx tx ( // @[UART.scala 105:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  Buffer buf$ ( // @[UART.scala 106:19]
    .clock(buf$_clock),
    .reset(buf$_reset),
    .io_in_ready(buf$_io_in_ready),
    .io_in_valid(buf$_io_in_valid),
    .io_in_bits(buf$_io_in_bits),
    .io_out_ready(buf$_io_out_ready),
    .io_out_valid(buf$_io_out_valid),
    .io_out_bits(buf$_io_out_bits)
  );
  assign io_txd = tx_io_txd;
  assign io_channel_ready = buf$_io_in_ready;
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = buf$_io_out_valid;
  assign tx_io_channel_bits = buf$_io_out_bits;
  assign buf$_clock = clock;
  assign buf$_reset = reset;
  assign buf$_io_in_valid = io_channel_valid;
  assign buf$_io_in_bits = io_channel_bits;
  assign buf$_io_out_ready = tx_io_channel_ready;
endmodule
module Rx(
  input        clock,
  input        reset,
  input        io_rxd,
  output       io_channel_valid,
  output [7:0] io_channel_bits
);
  reg [7:0] shiftReg; // @[UART.scala 119:25]
  reg [31:0] _RAND_0;
  reg [1:0] state; // @[UART.scala 121:22]
  reg [31:0] _RAND_1;
  reg [11:0] value; // @[Counter.scala 26:33]
  reg [31:0] _RAND_2;
  reg [11:0] value_1; // @[Counter.scala 26:33]
  reg [31:0] _RAND_3;
  reg [2:0] value_2; // @[Counter.scala 26:33]
  reg [31:0] _RAND_4;
  reg  _T_50; // @[UART.scala 138:30]
  reg [31:0] _RAND_5;
  wire  _T_16; // @[UART.scala 127:53]
  wire  _T_20; // @[Counter.scala 34:24]
  wire [12:0] _T_22; // @[Counter.scala 35:22]
  wire [11:0] _T_23; // @[Counter.scala 35:22]
  wire [11:0] _GEN_0; // @[Counter.scala 37:21]
  wire [11:0] _GEN_1; // @[Counter.scala 63:17]
  wire  first_wrap_out; // @[Counter.scala 64:20]
  wire  _T_25; // @[UART.scala 128:51]
  wire  _T_26; // @[UART.scala 128:74]
  wire  _T_27; // @[UART.scala 128:65]
  wire  _T_31; // @[Counter.scala 34:24]
  wire [12:0] _T_33; // @[Counter.scala 35:22]
  wire [11:0] _T_34; // @[Counter.scala 35:22]
  wire [11:0] _GEN_2; // @[Counter.scala 37:21]
  wire [11:0] _GEN_3; // @[Counter.scala 63:17]
  wire  baud_wrap_out; // @[Counter.scala 64:20]
  wire  _T_36; // @[UART.scala 129:58]
  wire  _T_37; // @[UART.scala 129:86]
  wire  _T_38; // @[UART.scala 129:77]
  wire  _T_42; // @[Counter.scala 34:24]
  wire [3:0] _T_44; // @[Counter.scala 35:22]
  wire [2:0] _T_45; // @[Counter.scala 35:22]
  wire [2:0] _GEN_4; // @[Counter.scala 63:17]
  wire  bit_wrap_out; // @[Counter.scala 64:20]
  wire [6:0] _T_47; // @[UART.scala 133:38]
  wire [7:0] _T_48; // @[Cat.scala 30:58]
  wire [7:0] _GEN_5; // @[UART.scala 132:41]
  wire  _T_51; // @[Conditional.scala 37:30]
  wire  _T_53; // @[UART.scala 143:19]
  wire [1:0] _GEN_6; // @[UART.scala 143:28]
  wire  _T_54; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_7; // @[UART.scala 148:28]
  wire  _T_55; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_8; // @[UART.scala 153:26]
  wire  _T_56; // @[Conditional.scala 37:30]
  wire [1:0] _GEN_9; // @[UART.scala 158:27]
  wire [1:0] _GEN_10; // @[Conditional.scala 39:67]
  wire [1:0] _GEN_11; // @[Conditional.scala 39:67]
  wire [1:0] _GEN_12; // @[Conditional.scala 39:67]
  wire [1:0] _GEN_13; // @[Conditional.scala 40:58]
  assign _T_16 = state == 2'h1; // @[UART.scala 127:53]
  assign _T_20 = value == 12'hcb5; // @[Counter.scala 34:24]
  assign _T_22 = value + 12'h1; // @[Counter.scala 35:22]
  assign _T_23 = _T_22[11:0]; // @[Counter.scala 35:22]
  assign _GEN_0 = _T_20 ? 12'h0 : _T_23; // @[Counter.scala 37:21]
  assign _GEN_1 = _T_16 ? _GEN_0 : value; // @[Counter.scala 63:17]
  assign first_wrap_out = _T_16 & _T_20; // @[Counter.scala 64:20]
  assign _T_25 = state == 2'h2; // @[UART.scala 128:51]
  assign _T_26 = state == 2'h3; // @[UART.scala 128:74]
  assign _T_27 = _T_25 | _T_26; // @[UART.scala 128:65]
  assign _T_31 = value_1 == 12'h878; // @[Counter.scala 34:24]
  assign _T_33 = value_1 + 12'h1; // @[Counter.scala 35:22]
  assign _T_34 = _T_33[11:0]; // @[Counter.scala 35:22]
  assign _GEN_2 = _T_31 ? 12'h0 : _T_34; // @[Counter.scala 37:21]
  assign _GEN_3 = _T_27 ? _GEN_2 : value_1; // @[Counter.scala 63:17]
  assign baud_wrap_out = _T_27 & _T_31; // @[Counter.scala 64:20]
  assign _T_36 = baud_wrap_out | first_wrap_out; // @[UART.scala 129:58]
  assign _T_37 = state != 2'h3; // @[UART.scala 129:86]
  assign _T_38 = _T_36 & _T_37; // @[UART.scala 129:77]
  assign _T_42 = value_2 == 3'h7; // @[Counter.scala 34:24]
  assign _T_44 = value_2 + 3'h1; // @[Counter.scala 35:22]
  assign _T_45 = _T_44[2:0]; // @[Counter.scala 35:22]
  assign _GEN_4 = _T_38 ? _T_45 : value_2; // @[Counter.scala 63:17]
  assign bit_wrap_out = _T_38 & _T_42; // @[Counter.scala 64:20]
  assign _T_47 = shiftReg[7:1]; // @[UART.scala 133:38]
  assign _T_48 = {io_rxd,_T_47}; // @[Cat.scala 30:58]
  assign _GEN_5 = _T_36 ? _T_48 : shiftReg; // @[UART.scala 132:41]
  assign _T_51 = 2'h0 == state; // @[Conditional.scala 37:30]
  assign _T_53 = io_rxd == 1'h0; // @[UART.scala 143:19]
  assign _GEN_6 = _T_53 ? 2'h1 : state; // @[UART.scala 143:28]
  assign _T_54 = 2'h1 == state; // @[Conditional.scala 37:30]
  assign _GEN_7 = first_wrap_out ? 2'h2 : state; // @[UART.scala 148:28]
  assign _T_55 = 2'h2 == state; // @[Conditional.scala 37:30]
  assign _GEN_8 = bit_wrap_out ? 2'h3 : state; // @[UART.scala 153:26]
  assign _T_56 = 2'h3 == state; // @[Conditional.scala 37:30]
  assign _GEN_9 = baud_wrap_out ? 2'h0 : state; // @[UART.scala 158:27]
  assign _GEN_10 = _T_56 ? _GEN_9 : state; // @[Conditional.scala 39:67]
  assign _GEN_11 = _T_55 ? _GEN_8 : _GEN_10; // @[Conditional.scala 39:67]
  assign _GEN_12 = _T_54 ? _GEN_7 : _GEN_11; // @[Conditional.scala 39:67]
  assign _GEN_13 = _T_51 ? _GEN_6 : _GEN_12; // @[Conditional.scala 40:58]
  assign io_channel_valid = _T_50;
  assign io_channel_bits = shiftReg;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  shiftReg = _RAND_0[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  state = _RAND_1[1:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  value = _RAND_2[11:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{$random}};
  value_1 = _RAND_3[11:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{$random}};
  value_2 = _RAND_4[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{$random}};
  _T_50 = _RAND_5[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      shiftReg <= 8'h0;
    end else begin
      if (_T_36) begin
        shiftReg <= _T_48;
      end
    end
    if (reset) begin
      state <= 2'h0;
    end else begin
      if (_T_51) begin
        if (_T_53) begin
          state <= 2'h1;
        end
      end else begin
        if (_T_54) begin
          if (first_wrap_out) begin
            state <= 2'h2;
          end
        end else begin
          if (_T_55) begin
            if (bit_wrap_out) begin
              state <= 2'h3;
            end
          end else begin
            if (_T_56) begin
              if (baud_wrap_out) begin
                state <= 2'h0;
              end
            end
          end
        end
      end
    end
    if (reset) begin
      value <= 12'h0;
    end else begin
      if (_T_16) begin
        if (_T_20) begin
          value <= 12'h0;
        end else begin
          value <= _T_23;
        end
      end
    end
    if (reset) begin
      value_1 <= 12'h0;
    end else begin
      if (_T_27) begin
        if (_T_31) begin
          value_1 <= 12'h0;
        end else begin
          value_1 <= _T_34;
        end
      end
    end
    if (reset) begin
      value_2 <= 3'h0;
    end else begin
      if (_T_38) begin
        value_2 <= _T_45;
      end
    end
    _T_50 <= bit_wrap_out;
  end
endmodule
module BufferedRx(
  input        clock,
  input        reset,
  input        io_rxd,
  input        io_channel_ready,
  output       io_channel_valid,
  output [7:0] io_channel_bits
);
  wire  rx_clock; // @[UART.scala 171:18]
  wire  rx_reset; // @[UART.scala 171:18]
  wire  rx_io_rxd; // @[UART.scala 171:18]
  wire  rx_io_channel_valid; // @[UART.scala 171:18]
  wire [7:0] rx_io_channel_bits; // @[UART.scala 171:18]
  wire  buf$_clock; // @[UART.scala 172:19]
  wire  buf$_reset; // @[UART.scala 172:19]
  wire  buf$_io_in_ready; // @[UART.scala 172:19]
  wire  buf$_io_in_valid; // @[UART.scala 172:19]
  wire [7:0] buf$_io_in_bits; // @[UART.scala 172:19]
  wire  buf$_io_out_ready; // @[UART.scala 172:19]
  wire  buf$_io_out_valid; // @[UART.scala 172:19]
  wire [7:0] buf$_io_out_bits; // @[UART.scala 172:19]
  Rx rx ( // @[UART.scala 171:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  Buffer buf$ ( // @[UART.scala 172:19]
    .clock(buf$_clock),
    .reset(buf$_reset),
    .io_in_ready(buf$_io_in_ready),
    .io_in_valid(buf$_io_in_valid),
    .io_in_bits(buf$_io_in_bits),
    .io_out_ready(buf$_io_out_ready),
    .io_out_valid(buf$_io_out_valid),
    .io_out_bits(buf$_io_out_bits)
  );
  assign io_channel_valid = buf$_io_out_valid;
  assign io_channel_bits = buf$_io_out_bits;
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd;
  assign buf$_clock = clock;
  assign buf$_reset = reset;
  assign buf$_io_in_valid = rx_io_channel_valid;
  assign buf$_io_in_bits = rx_io_channel_bits;
  assign buf$_io_out_ready = io_channel_ready;
endmodule
module Uart(
  input        clock,
  input        reset,
  input        io_rxd,
  output       io_txd,
  input        io_rxChannel_ready,
  output       io_rxChannel_valid,
  output [7:0] io_rxChannel_bits,
  output       io_txChannel_ready,
  input        io_txChannel_valid,
  input  [7:0] io_txChannel_bits
);
  wire  tx_clock; // @[UART.scala 256:18]
  wire  tx_reset; // @[UART.scala 256:18]
  wire  tx_io_txd; // @[UART.scala 256:18]
  wire  tx_io_channel_ready; // @[UART.scala 256:18]
  wire  tx_io_channel_valid; // @[UART.scala 256:18]
  wire [7:0] tx_io_channel_bits; // @[UART.scala 256:18]
  wire  rx_clock; // @[UART.scala 257:18]
  wire  rx_reset; // @[UART.scala 257:18]
  wire  rx_io_rxd; // @[UART.scala 257:18]
  wire  rx_io_channel_ready; // @[UART.scala 257:18]
  wire  rx_io_channel_valid; // @[UART.scala 257:18]
  wire [7:0] rx_io_channel_bits; // @[UART.scala 257:18]
  BufferedTx tx ( // @[UART.scala 256:18]
    .clock(tx_clock),
    .reset(tx_reset),
    .io_txd(tx_io_txd),
    .io_channel_ready(tx_io_channel_ready),
    .io_channel_valid(tx_io_channel_valid),
    .io_channel_bits(tx_io_channel_bits)
  );
  BufferedRx rx ( // @[UART.scala 257:18]
    .clock(rx_clock),
    .reset(rx_reset),
    .io_rxd(rx_io_rxd),
    .io_channel_ready(rx_io_channel_ready),
    .io_channel_valid(rx_io_channel_valid),
    .io_channel_bits(rx_io_channel_bits)
  );
  assign io_txd = tx_io_txd;
  assign io_rxChannel_valid = rx_io_channel_valid;
  assign io_rxChannel_bits = rx_io_channel_bits;
  assign io_txChannel_ready = tx_io_channel_ready;
  assign tx_clock = clock;
  assign tx_reset = reset;
  assign tx_io_channel_valid = io_txChannel_valid;
  assign tx_io_channel_bits = io_txChannel_bits;
  assign rx_clock = clock;
  assign rx_reset = reset;
  assign rx_io_rxd = io_rxd;
  assign rx_io_channel_ready = io_rxChannel_ready;
endmodule
module LEDController(
  input         clock,
  input         reset,
  input         io_cpu_req_valid,
  input  [31:0] io_cpu_req_bits_data,
  output [3:0]  io_leds
);
  reg [3:0] ledState; // @[LEDController.scala 16:25]
  reg [31:0] _RAND_0;
  wire [3:0] _T_25; // @[LEDController.scala 22:36]
  wire [3:0] _GEN_0; // @[LEDController.scala 21:25]
  assign _T_25 = io_cpu_req_bits_data[3:0]; // @[LEDController.scala 22:36]
  assign _GEN_0 = io_cpu_req_valid ? _T_25 : ledState; // @[LEDController.scala 21:25]
  assign io_leds = ledState;
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  ledState = _RAND_0[3:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      ledState <= 4'h0;
    end else begin
      if (io_cpu_req_valid) begin
        ledState <= _T_25;
      end
    end
  end
endmodule
module UartController(
  input         clock,
  input         reset,
  input         io_cpu_req_valid,
  input  [31:0] io_cpu_req_bits_addr,
  input  [31:0] io_cpu_req_bits_data,
  output        io_cpu_resp_valid,
  output [31:0] io_cpu_resp_bits_data,
  output        io_rxChannel_ready,
  input         io_rxChannel_valid,
  input  [7:0]  io_rxChannel_bits,
  input         io_txChannel_ready,
  output        io_txChannel_valid,
  output [7:0]  io_txChannel_bits
);
  reg [2:0] state; // @[UART.scala 188:22]
  reg [31:0] _RAND_0;
  reg [31:0] rdata; // @[Reg.scala 11:16]
  reg [31:0] _RAND_1;
  reg [31:0] wdata; // @[UART.scala 196:22]
  reg [31:0] _RAND_2;
  wire  is_READ_READ_STATE; // @[UART.scala 190:34]
  wire  is_READ_WRITE_STATE; // @[UART.scala 191:35]
  wire  is_READ_DATA; // @[UART.scala 192:28]
  wire  _T_42; // @[UART.scala 195:66]
  wire  _T_43; // @[UART.scala 195:89]
  wire [31:0] _GEN_0; // @[Reg.scala 12:19]
  wire  _T_51; // @[Conditional.scala 37:30]
  wire  _T_57; // @[Mux.scala 46:19]
  wire [2:0] _T_58; // @[Mux.scala 46:16]
  wire  _T_59; // @[Mux.scala 46:19]
  wire [2:0] _T_60; // @[Mux.scala 46:16]
  wire  _T_61; // @[Mux.scala 46:19]
  wire [2:0] _T_62; // @[Mux.scala 46:16]
  wire  _T_63; // @[Mux.scala 46:19]
  wire [2:0] _T_64; // @[Mux.scala 46:16]
  wire [31:0] _GEN_2; // @[UART.scala 207:31]
  wire [2:0] _GEN_3; // @[UART.scala 207:31]
  wire  _T_65; // @[Conditional.scala 37:30]
  wire  _T_72; // @[Conditional.scala 37:30]
  wire  _T_79; // @[Conditional.scala 37:30]
  wire  _T_81; // @[Decoupled.scala 37:37]
  wire [7:0] _T_83; // @[UART.scala 235:60]
  wire  _T_86; // @[UART.scala 235:15]
  wire [31:0] _GEN_4; // @[UART.scala 230:33]
  wire [2:0] _GEN_6; // @[UART.scala 230:33]
  wire  _T_87; // @[Conditional.scala 37:30]
  wire [7:0] _T_88; // @[UART.scala 239:33]
  wire  _T_90; // @[Decoupled.scala 37:37]
  wire [2:0] _GEN_7; // @[UART.scala 241:33]
  wire [7:0] _GEN_8; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_10; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_12; // @[Conditional.scala 39:67]
  wire  _GEN_13; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_14; // @[Conditional.scala 39:67]
  wire [7:0] _GEN_15; // @[Conditional.scala 39:67]
  wire  _GEN_16; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_17; // @[Conditional.scala 39:67]
  wire  _GEN_18; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_19; // @[Conditional.scala 39:67]
  wire  _GEN_20; // @[Conditional.scala 39:67]
  wire [7:0] _GEN_21; // @[Conditional.scala 39:67]
  wire  _GEN_22; // @[Conditional.scala 39:67]
  wire [31:0] _GEN_23; // @[Conditional.scala 39:67]
  wire  _GEN_24; // @[Conditional.scala 39:67]
  wire [2:0] _GEN_25; // @[Conditional.scala 39:67]
  wire  _GEN_26; // @[Conditional.scala 39:67]
  wire [7:0] _GEN_27; // @[Conditional.scala 39:67]
  wire  _GEN_28; // @[Conditional.scala 39:67]
  wire  _GEN_29; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_31; // @[Conditional.scala 40:58]
  wire [2:0] _GEN_32; // @[Conditional.scala 40:58]
  wire [31:0] _GEN_33; // @[Conditional.scala 40:58]
  wire  _GEN_34; // @[Conditional.scala 40:58]
  wire [7:0] _GEN_35; // @[Conditional.scala 40:58]
  wire  _GEN_36; // @[Conditional.scala 40:58]
  wire  _GEN_37; // @[UART.scala 235:15]
  wire  _GEN_38; // @[UART.scala 235:15]
  wire  _GEN_39; // @[UART.scala 235:15]
  wire  _GEN_40; // @[UART.scala 235:15]
  wire  _GEN_41; // @[UART.scala 235:15]
  wire  _GEN_42; // @[UART.scala 235:15]
  wire  _GEN_43; // @[UART.scala 235:15]
  assign is_READ_READ_STATE = state == 3'h1; // @[UART.scala 190:34]
  assign is_READ_WRITE_STATE = state == 3'h2; // @[UART.scala 191:35]
  assign is_READ_DATA = state == 3'h3; // @[UART.scala 192:28]
  assign _T_42 = is_READ_READ_STATE | is_READ_WRITE_STATE; // @[UART.scala 195:66]
  assign _T_43 = _T_42 | is_READ_DATA; // @[UART.scala 195:89]
  assign _GEN_0 = _T_43 ? io_cpu_resp_bits_data : rdata; // @[Reg.scala 12:19]
  assign _T_51 = 3'h0 == state; // @[Conditional.scala 37:30]
  assign _T_57 = 32'h1000000c == io_cpu_req_bits_addr; // @[Mux.scala 46:19]
  assign _T_58 = _T_57 ? 3'h4 : 3'h0; // @[Mux.scala 46:16]
  assign _T_59 = 32'h10000008 == io_cpu_req_bits_addr; // @[Mux.scala 46:19]
  assign _T_60 = _T_59 ? 3'h2 : _T_58; // @[Mux.scala 46:16]
  assign _T_61 = 32'h10000004 == io_cpu_req_bits_addr; // @[Mux.scala 46:19]
  assign _T_62 = _T_61 ? 3'h3 : _T_60; // @[Mux.scala 46:16]
  assign _T_63 = 32'h10000000 == io_cpu_req_bits_addr; // @[Mux.scala 46:19]
  assign _T_64 = _T_63 ? 3'h1 : _T_62; // @[Mux.scala 46:16]
  assign _GEN_2 = io_cpu_req_valid ? io_cpu_req_bits_data : wdata; // @[UART.scala 207:31]
  assign _GEN_3 = io_cpu_req_valid ? _T_64 : state; // @[UART.scala 207:31]
  assign _T_65 = 3'h1 == state; // @[Conditional.scala 37:30]
  assign _T_72 = 3'h2 == state; // @[Conditional.scala 37:30]
  assign _T_79 = 3'h3 == state; // @[Conditional.scala 37:30]
  assign _T_81 = io_rxChannel_ready & io_rxChannel_valid; // @[Decoupled.scala 37:37]
  assign _T_83 = io_cpu_resp_bits_data[7:0]; // @[UART.scala 235:60]
  assign _T_86 = reset == 1'h0; // @[UART.scala 235:15]
  assign _GEN_4 = _T_81 ? {{24'd0}, io_rxChannel_bits} : rdata; // @[UART.scala 230:33]
  assign _GEN_6 = _T_81 ? 3'h0 : state; // @[UART.scala 230:33]
  assign _T_87 = 3'h4 == state; // @[Conditional.scala 37:30]
  assign _T_88 = wdata[7:0]; // @[UART.scala 239:33]
  assign _T_90 = io_txChannel_ready & io_txChannel_valid; // @[Decoupled.scala 37:37]
  assign _GEN_7 = _T_90 ? 3'h0 : state; // @[UART.scala 241:33]
  assign _GEN_8 = _T_87 ? _T_88 : 8'h0; // @[Conditional.scala 39:67]
  assign _GEN_10 = _T_87 ? _GEN_7 : state; // @[Conditional.scala 39:67]
  assign _GEN_12 = _T_79 ? _GEN_4 : rdata; // @[Conditional.scala 39:67]
  assign _GEN_13 = _T_79 ? _T_81 : 1'h0; // @[Conditional.scala 39:67]
  assign _GEN_14 = _T_79 ? _GEN_6 : _GEN_10; // @[Conditional.scala 39:67]
  assign _GEN_15 = _T_79 ? 8'h0 : _GEN_8; // @[Conditional.scala 39:67]
  assign _GEN_16 = _T_79 ? 1'h0 : _T_87; // @[Conditional.scala 39:67]
  assign _GEN_17 = _T_72 ? {{31'd0}, io_txChannel_ready} : _GEN_12; // @[Conditional.scala 39:67]
  assign _GEN_18 = _T_72 ? 1'h1 : _GEN_13; // @[Conditional.scala 39:67]
  assign _GEN_19 = _T_72 ? 3'h0 : _GEN_14; // @[Conditional.scala 39:67]
  assign _GEN_20 = _T_72 ? 1'h0 : _T_79; // @[Conditional.scala 39:67]
  assign _GEN_21 = _T_72 ? 8'h0 : _GEN_15; // @[Conditional.scala 39:67]
  assign _GEN_22 = _T_72 ? 1'h0 : _GEN_16; // @[Conditional.scala 39:67]
  assign _GEN_23 = _T_65 ? {{31'd0}, io_rxChannel_valid} : _GEN_17; // @[Conditional.scala 39:67]
  assign _GEN_24 = _T_65 ? 1'h1 : _GEN_18; // @[Conditional.scala 39:67]
  assign _GEN_25 = _T_65 ? 3'h0 : _GEN_19; // @[Conditional.scala 39:67]
  assign _GEN_26 = _T_65 ? 1'h0 : _GEN_20; // @[Conditional.scala 39:67]
  assign _GEN_27 = _T_65 ? 8'h0 : _GEN_21; // @[Conditional.scala 39:67]
  assign _GEN_28 = _T_65 ? 1'h0 : _GEN_22; // @[Conditional.scala 39:67]
  assign _GEN_29 = _T_51 ? 1'h1 : _GEN_24; // @[Conditional.scala 40:58]
  assign _GEN_31 = _T_51 ? _GEN_2 : wdata; // @[Conditional.scala 40:58]
  assign _GEN_32 = _T_51 ? _GEN_3 : _GEN_25; // @[Conditional.scala 40:58]
  assign _GEN_33 = _T_51 ? rdata : _GEN_23; // @[Conditional.scala 40:58]
  assign _GEN_34 = _T_51 ? 1'h0 : _GEN_26; // @[Conditional.scala 40:58]
  assign _GEN_35 = _T_51 ? 8'h0 : _GEN_27; // @[Conditional.scala 40:58]
  assign _GEN_36 = _T_51 ? 1'h0 : _GEN_28; // @[Conditional.scala 40:58]
  assign io_cpu_resp_valid = _GEN_29;
  assign io_cpu_resp_bits_data = _GEN_33;
  assign io_rxChannel_ready = _GEN_34;
  assign io_txChannel_valid = _GEN_36;
  assign io_txChannel_bits = _GEN_35;
  assign _GEN_37 = _T_51 == 1'h0; // @[UART.scala 235:15]
  assign _GEN_38 = _T_65 == 1'h0; // @[UART.scala 235:15]
  assign _GEN_39 = _GEN_37 & _GEN_38; // @[UART.scala 235:15]
  assign _GEN_40 = _T_72 == 1'h0; // @[UART.scala 235:15]
  assign _GEN_41 = _GEN_39 & _GEN_40; // @[UART.scala 235:15]
  assign _GEN_42 = _GEN_41 & _T_79; // @[UART.scala 235:15]
  assign _GEN_43 = _GEN_42 & _T_81; // @[UART.scala 235:15]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  state = _RAND_0[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  rdata = _RAND_1[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  wdata = _RAND_2[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      state <= 3'h0;
    end else begin
      if (_T_51) begin
        if (io_cpu_req_valid) begin
          if (_T_63) begin
            state <= 3'h1;
          end else begin
            if (_T_61) begin
              state <= 3'h3;
            end else begin
              if (_T_59) begin
                state <= 3'h2;
              end else begin
                if (_T_57) begin
                  state <= 3'h4;
                end else begin
                  state <= 3'h0;
                end
              end
            end
          end
        end
      end else begin
        if (_T_65) begin
          state <= 3'h0;
        end else begin
          if (_T_72) begin
            state <= 3'h0;
          end else begin
            if (_T_79) begin
              if (_T_81) begin
                state <= 3'h0;
              end
            end else begin
              if (_T_87) begin
                if (_T_90) begin
                  state <= 3'h0;
                end
              end
            end
          end
        end
      end
    end
    if (_T_43) begin
      rdata <= io_cpu_resp_bits_data;
    end
    if (reset) begin
      wdata <= 32'h0;
    end else begin
      if (_T_51) begin
        if (io_cpu_req_valid) begin
          wdata <= io_cpu_req_bits_data;
        end
      end
    end
    `ifndef SYNTHESIS
    `ifdef PRINTF_COND
      if (`PRINTF_COND) begin
    `endif
        if (_GEN_43 & _T_86) begin
          $fwrite(32'h80000002,"core received: %c\n",_T_83); // @[UART.scala 235:15]
        end
    `ifdef PRINTF_COND
      end
    `endif
    `endif // SYNTHESIS
  end
endmodule
module Tile(
  input        clock,
  input        reset,
  output       io_txd,
  input        io_rxd,
  output [3:0] io_ledState
);
  wire  core_clock; // @[Tile.scala 110:31]
  wire  core_reset; // @[Tile.scala 110:31]
  wire  core_io_icache_req_valid; // @[Tile.scala 110:31]
  wire [31:0] core_io_icache_req_bits_addr; // @[Tile.scala 110:31]
  wire  core_io_icache_resp_valid; // @[Tile.scala 110:31]
  wire [31:0] core_io_icache_resp_bits_data; // @[Tile.scala 110:31]
  wire  core_io_dcache_abort; // @[Tile.scala 110:31]
  wire  core_io_dcache_req_valid; // @[Tile.scala 110:31]
  wire [31:0] core_io_dcache_req_bits_addr; // @[Tile.scala 110:31]
  wire [31:0] core_io_dcache_req_bits_data; // @[Tile.scala 110:31]
  wire [3:0] core_io_dcache_req_bits_mask; // @[Tile.scala 110:31]
  wire  core_io_dcache_resp_valid; // @[Tile.scala 110:31]
  wire [31:0] core_io_dcache_resp_bits_data; // @[Tile.scala 110:31]
  wire  icache_clock; // @[Tile.scala 111:31]
  wire  icache_reset; // @[Tile.scala 111:31]
  wire  icache_io_cpu_abort; // @[Tile.scala 111:31]
  wire  icache_io_cpu_req_valid; // @[Tile.scala 111:31]
  wire [31:0] icache_io_cpu_req_bits_addr; // @[Tile.scala 111:31]
  wire [31:0] icache_io_cpu_req_bits_data; // @[Tile.scala 111:31]
  wire [3:0] icache_io_cpu_req_bits_mask; // @[Tile.scala 111:31]
  wire  icache_io_cpu_resp_valid; // @[Tile.scala 111:31]
  wire [31:0] icache_io_cpu_resp_bits_data; // @[Tile.scala 111:31]
  wire  icache_io_nasti_aw_ready; // @[Tile.scala 111:31]
  wire  icache_io_nasti_aw_valid; // @[Tile.scala 111:31]
  wire [31:0] icache_io_nasti_aw_bits_addr; // @[Tile.scala 111:31]
  wire  icache_io_nasti_w_ready; // @[Tile.scala 111:31]
  wire  icache_io_nasti_w_valid; // @[Tile.scala 111:31]
  wire [63:0] icache_io_nasti_w_bits_data; // @[Tile.scala 111:31]
  wire  icache_io_nasti_w_bits_last; // @[Tile.scala 111:31]
  wire  icache_io_nasti_b_ready; // @[Tile.scala 111:31]
  wire  icache_io_nasti_b_valid; // @[Tile.scala 111:31]
  wire  icache_io_nasti_ar_ready; // @[Tile.scala 111:31]
  wire  icache_io_nasti_ar_valid; // @[Tile.scala 111:31]
  wire [31:0] icache_io_nasti_ar_bits_addr; // @[Tile.scala 111:31]
  wire  icache_io_nasti_r_ready; // @[Tile.scala 111:31]
  wire  icache_io_nasti_r_valid; // @[Tile.scala 111:31]
  wire [63:0] icache_io_nasti_r_bits_data; // @[Tile.scala 111:31]
  wire  dcache_clock; // @[Tile.scala 112:31]
  wire  dcache_reset; // @[Tile.scala 112:31]
  wire  dcache_io_cpu_abort; // @[Tile.scala 112:31]
  wire  dcache_io_cpu_req_valid; // @[Tile.scala 112:31]
  wire [31:0] dcache_io_cpu_req_bits_addr; // @[Tile.scala 112:31]
  wire [31:0] dcache_io_cpu_req_bits_data; // @[Tile.scala 112:31]
  wire [3:0] dcache_io_cpu_req_bits_mask; // @[Tile.scala 112:31]
  wire  dcache_io_cpu_resp_valid; // @[Tile.scala 112:31]
  wire [31:0] dcache_io_cpu_resp_bits_data; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_aw_ready; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_aw_valid; // @[Tile.scala 112:31]
  wire [31:0] dcache_io_nasti_aw_bits_addr; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_w_ready; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_w_valid; // @[Tile.scala 112:31]
  wire [63:0] dcache_io_nasti_w_bits_data; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_w_bits_last; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_b_ready; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_b_valid; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_ar_ready; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_ar_valid; // @[Tile.scala 112:31]
  wire [31:0] dcache_io_nasti_ar_bits_addr; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_r_ready; // @[Tile.scala 112:31]
  wire  dcache_io_nasti_r_valid; // @[Tile.scala 112:31]
  wire [63:0] dcache_io_nasti_r_bits_data; // @[Tile.scala 112:31]
  wire  arb_clock; // @[Tile.scala 113:31]
  wire  arb_reset; // @[Tile.scala 113:31]
  wire  arb_io_icache_ar_ready; // @[Tile.scala 113:31]
  wire  arb_io_icache_ar_valid; // @[Tile.scala 113:31]
  wire [31:0] arb_io_icache_ar_bits_addr; // @[Tile.scala 113:31]
  wire  arb_io_icache_r_ready; // @[Tile.scala 113:31]
  wire  arb_io_icache_r_valid; // @[Tile.scala 113:31]
  wire [63:0] arb_io_icache_r_bits_data; // @[Tile.scala 113:31]
  wire  arb_io_dcache_aw_ready; // @[Tile.scala 113:31]
  wire  arb_io_dcache_aw_valid; // @[Tile.scala 113:31]
  wire [31:0] arb_io_dcache_aw_bits_addr; // @[Tile.scala 113:31]
  wire  arb_io_dcache_w_ready; // @[Tile.scala 113:31]
  wire  arb_io_dcache_w_valid; // @[Tile.scala 113:31]
  wire [63:0] arb_io_dcache_w_bits_data; // @[Tile.scala 113:31]
  wire  arb_io_dcache_w_bits_last; // @[Tile.scala 113:31]
  wire  arb_io_dcache_b_ready; // @[Tile.scala 113:31]
  wire  arb_io_dcache_b_valid; // @[Tile.scala 113:31]
  wire  arb_io_dcache_ar_ready; // @[Tile.scala 113:31]
  wire  arb_io_dcache_ar_valid; // @[Tile.scala 113:31]
  wire [31:0] arb_io_dcache_ar_bits_addr; // @[Tile.scala 113:31]
  wire  arb_io_dcache_r_ready; // @[Tile.scala 113:31]
  wire  arb_io_dcache_r_valid; // @[Tile.scala 113:31]
  wire [63:0] arb_io_dcache_r_bits_data; // @[Tile.scala 113:31]
  wire  arb_io_nasti_aw_ready; // @[Tile.scala 113:31]
  wire  arb_io_nasti_aw_valid; // @[Tile.scala 113:31]
  wire [31:0] arb_io_nasti_aw_bits_addr; // @[Tile.scala 113:31]
  wire  arb_io_nasti_w_ready; // @[Tile.scala 113:31]
  wire  arb_io_nasti_w_valid; // @[Tile.scala 113:31]
  wire [63:0] arb_io_nasti_w_bits_data; // @[Tile.scala 113:31]
  wire  arb_io_nasti_w_bits_last; // @[Tile.scala 113:31]
  wire  arb_io_nasti_b_ready; // @[Tile.scala 113:31]
  wire  arb_io_nasti_b_valid; // @[Tile.scala 113:31]
  wire  arb_io_nasti_ar_ready; // @[Tile.scala 113:31]
  wire  arb_io_nasti_ar_valid; // @[Tile.scala 113:31]
  wire [31:0] arb_io_nasti_ar_bits_addr; // @[Tile.scala 113:31]
  wire  arb_io_nasti_r_ready; // @[Tile.scala 113:31]
  wire  arb_io_nasti_r_valid; // @[Tile.scala 113:31]
  wire [63:0] arb_io_nasti_r_bits_data; // @[Tile.scala 113:31]
  wire  arb_io_nasti_r_bits_last; // @[Tile.scala 113:31]
  wire  mmio_clock; // @[Tile.scala 114:31]
  wire  mmio_reset; // @[Tile.scala 114:31]
  wire  mmio_io_cpu_abort; // @[Tile.scala 114:31]
  wire  mmio_io_cpu_req_valid; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_cpu_req_bits_addr; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_cpu_req_bits_data; // @[Tile.scala 114:31]
  wire [3:0] mmio_io_cpu_req_bits_mask; // @[Tile.scala 114:31]
  wire  mmio_io_cpu_resp_valid; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_cpu_resp_bits_data; // @[Tile.scala 114:31]
  wire  mmio_io_dcache_abort; // @[Tile.scala 114:31]
  wire  mmio_io_dcache_req_valid; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_dcache_req_bits_addr; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_dcache_req_bits_data; // @[Tile.scala 114:31]
  wire [3:0] mmio_io_dcache_req_bits_mask; // @[Tile.scala 114:31]
  wire  mmio_io_dcache_resp_valid; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_dcache_resp_bits_data; // @[Tile.scala 114:31]
  wire  mmio_io_uart_req_valid; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_uart_req_bits_addr; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_uart_req_bits_data; // @[Tile.scala 114:31]
  wire  mmio_io_uart_resp_valid; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_uart_resp_bits_data; // @[Tile.scala 114:31]
  wire  mmio_io_ledController_req_valid; // @[Tile.scala 114:31]
  wire [31:0] mmio_io_ledController_req_bits_data; // @[Tile.scala 114:31]
  wire  bram_s_axi_rready; // @[Tile.scala 115:31]
  wire  bram_s_axi_rvalid; // @[Tile.scala 115:31]
  wire  bram_s_axi_rlast; // @[Tile.scala 115:31]
  wire [1:0] bram_s_axi_rresp; // @[Tile.scala 115:31]
  wire [63:0] bram_s_axi_rdata; // @[Tile.scala 115:31]
  wire [3:0] bram_s_axi_rid; // @[Tile.scala 115:31]
  wire  bram_s_axi_arready; // @[Tile.scala 115:31]
  wire  bram_s_axi_arvalid; // @[Tile.scala 115:31]
  wire [1:0] bram_s_axi_arburst; // @[Tile.scala 115:31]
  wire [2:0] bram_s_axi_arsize; // @[Tile.scala 115:31]
  wire [7:0] bram_s_axi_arlen; // @[Tile.scala 115:31]
  wire [31:0] bram_s_axi_araddr; // @[Tile.scala 115:31]
  wire [3:0] bram_s_axi_arid; // @[Tile.scala 115:31]
  wire  bram_s_axi_bready; // @[Tile.scala 115:31]
  wire  bram_s_axi_bvalid; // @[Tile.scala 115:31]
  wire [1:0] bram_s_axi_bresp; // @[Tile.scala 115:31]
  wire [3:0] bram_s_axi_bid; // @[Tile.scala 115:31]
  wire  bram_s_axi_wready; // @[Tile.scala 115:31]
  wire  bram_s_axi_wvalid; // @[Tile.scala 115:31]
  wire  bram_s_axi_wlast; // @[Tile.scala 115:31]
  wire [7:0] bram_s_axi_wstrb; // @[Tile.scala 115:31]
  wire [63:0] bram_s_axi_wdata; // @[Tile.scala 115:31]
  wire  bram_s_axi_awready; // @[Tile.scala 115:31]
  wire  bram_s_axi_awvalid; // @[Tile.scala 115:31]
  wire [1:0] bram_s_axi_awburst; // @[Tile.scala 115:31]
  wire [2:0] bram_s_axi_awsize; // @[Tile.scala 115:31]
  wire [7:0] bram_s_axi_awlen; // @[Tile.scala 115:31]
  wire [31:0] bram_s_axi_awaddr; // @[Tile.scala 115:31]
  wire [3:0] bram_s_axi_awid; // @[Tile.scala 115:31]
  wire  bram_s_aresetn; // @[Tile.scala 115:31]
  wire  bram_s_aclk; // @[Tile.scala 115:31]
  wire  uart_clock; // @[Tile.scala 118:31]
  wire  uart_reset; // @[Tile.scala 118:31]
  wire  uart_io_rxd; // @[Tile.scala 118:31]
  wire  uart_io_txd; // @[Tile.scala 118:31]
  wire  uart_io_rxChannel_ready; // @[Tile.scala 118:31]
  wire  uart_io_rxChannel_valid; // @[Tile.scala 118:31]
  wire [7:0] uart_io_rxChannel_bits; // @[Tile.scala 118:31]
  wire  uart_io_txChannel_ready; // @[Tile.scala 118:31]
  wire  uart_io_txChannel_valid; // @[Tile.scala 118:31]
  wire [7:0] uart_io_txChannel_bits; // @[Tile.scala 118:31]
  wire  ledController_clock; // @[Tile.scala 119:31]
  wire  ledController_reset; // @[Tile.scala 119:31]
  wire  ledController_io_cpu_req_valid; // @[Tile.scala 119:31]
  wire [31:0] ledController_io_cpu_req_bits_data; // @[Tile.scala 119:31]
  wire [3:0] ledController_io_leds; // @[Tile.scala 119:31]
  wire  uartController_clock; // @[Tile.scala 120:31]
  wire  uartController_reset; // @[Tile.scala 120:31]
  wire  uartController_io_cpu_req_valid; // @[Tile.scala 120:31]
  wire [31:0] uartController_io_cpu_req_bits_addr; // @[Tile.scala 120:31]
  wire [31:0] uartController_io_cpu_req_bits_data; // @[Tile.scala 120:31]
  wire  uartController_io_cpu_resp_valid; // @[Tile.scala 120:31]
  wire [31:0] uartController_io_cpu_resp_bits_data; // @[Tile.scala 120:31]
  wire  uartController_io_rxChannel_ready; // @[Tile.scala 120:31]
  wire  uartController_io_rxChannel_valid; // @[Tile.scala 120:31]
  wire [7:0] uartController_io_rxChannel_bits; // @[Tile.scala 120:31]
  wire  uartController_io_txChannel_ready; // @[Tile.scala 120:31]
  wire  uartController_io_txChannel_valid; // @[Tile.scala 120:31]
  wire [7:0] uartController_io_txChannel_bits; // @[Tile.scala 120:31]
  wire  _T_15; // @[Tile.scala 146:24]
  Core core ( // @[Tile.scala 110:31]
    .clock(core_clock),
    .reset(core_reset),
    .io_icache_req_valid(core_io_icache_req_valid),
    .io_icache_req_bits_addr(core_io_icache_req_bits_addr),
    .io_icache_resp_valid(core_io_icache_resp_valid),
    .io_icache_resp_bits_data(core_io_icache_resp_bits_data),
    .io_dcache_abort(core_io_dcache_abort),
    .io_dcache_req_valid(core_io_dcache_req_valid),
    .io_dcache_req_bits_addr(core_io_dcache_req_bits_addr),
    .io_dcache_req_bits_data(core_io_dcache_req_bits_data),
    .io_dcache_req_bits_mask(core_io_dcache_req_bits_mask),
    .io_dcache_resp_valid(core_io_dcache_resp_valid),
    .io_dcache_resp_bits_data(core_io_dcache_resp_bits_data)
  );
  Cache icache ( // @[Tile.scala 111:31]
    .clock(icache_clock),
    .reset(icache_reset),
    .io_cpu_abort(icache_io_cpu_abort),
    .io_cpu_req_valid(icache_io_cpu_req_valid),
    .io_cpu_req_bits_addr(icache_io_cpu_req_bits_addr),
    .io_cpu_req_bits_data(icache_io_cpu_req_bits_data),
    .io_cpu_req_bits_mask(icache_io_cpu_req_bits_mask),
    .io_cpu_resp_valid(icache_io_cpu_resp_valid),
    .io_cpu_resp_bits_data(icache_io_cpu_resp_bits_data),
    .io_nasti_aw_ready(icache_io_nasti_aw_ready),
    .io_nasti_aw_valid(icache_io_nasti_aw_valid),
    .io_nasti_aw_bits_addr(icache_io_nasti_aw_bits_addr),
    .io_nasti_w_ready(icache_io_nasti_w_ready),
    .io_nasti_w_valid(icache_io_nasti_w_valid),
    .io_nasti_w_bits_data(icache_io_nasti_w_bits_data),
    .io_nasti_w_bits_last(icache_io_nasti_w_bits_last),
    .io_nasti_b_ready(icache_io_nasti_b_ready),
    .io_nasti_b_valid(icache_io_nasti_b_valid),
    .io_nasti_ar_ready(icache_io_nasti_ar_ready),
    .io_nasti_ar_valid(icache_io_nasti_ar_valid),
    .io_nasti_ar_bits_addr(icache_io_nasti_ar_bits_addr),
    .io_nasti_r_ready(icache_io_nasti_r_ready),
    .io_nasti_r_valid(icache_io_nasti_r_valid),
    .io_nasti_r_bits_data(icache_io_nasti_r_bits_data)
  );
  Cache dcache ( // @[Tile.scala 112:31]
    .clock(dcache_clock),
    .reset(dcache_reset),
    .io_cpu_abort(dcache_io_cpu_abort),
    .io_cpu_req_valid(dcache_io_cpu_req_valid),
    .io_cpu_req_bits_addr(dcache_io_cpu_req_bits_addr),
    .io_cpu_req_bits_data(dcache_io_cpu_req_bits_data),
    .io_cpu_req_bits_mask(dcache_io_cpu_req_bits_mask),
    .io_cpu_resp_valid(dcache_io_cpu_resp_valid),
    .io_cpu_resp_bits_data(dcache_io_cpu_resp_bits_data),
    .io_nasti_aw_ready(dcache_io_nasti_aw_ready),
    .io_nasti_aw_valid(dcache_io_nasti_aw_valid),
    .io_nasti_aw_bits_addr(dcache_io_nasti_aw_bits_addr),
    .io_nasti_w_ready(dcache_io_nasti_w_ready),
    .io_nasti_w_valid(dcache_io_nasti_w_valid),
    .io_nasti_w_bits_data(dcache_io_nasti_w_bits_data),
    .io_nasti_w_bits_last(dcache_io_nasti_w_bits_last),
    .io_nasti_b_ready(dcache_io_nasti_b_ready),
    .io_nasti_b_valid(dcache_io_nasti_b_valid),
    .io_nasti_ar_ready(dcache_io_nasti_ar_ready),
    .io_nasti_ar_valid(dcache_io_nasti_ar_valid),
    .io_nasti_ar_bits_addr(dcache_io_nasti_ar_bits_addr),
    .io_nasti_r_ready(dcache_io_nasti_r_ready),
    .io_nasti_r_valid(dcache_io_nasti_r_valid),
    .io_nasti_r_bits_data(dcache_io_nasti_r_bits_data)
  );
  MemArbiter arb ( // @[Tile.scala 113:31]
    .clock(arb_clock),
    .reset(arb_reset),
    .io_icache_ar_ready(arb_io_icache_ar_ready),
    .io_icache_ar_valid(arb_io_icache_ar_valid),
    .io_icache_ar_bits_addr(arb_io_icache_ar_bits_addr),
    .io_icache_r_ready(arb_io_icache_r_ready),
    .io_icache_r_valid(arb_io_icache_r_valid),
    .io_icache_r_bits_data(arb_io_icache_r_bits_data),
    .io_dcache_aw_ready(arb_io_dcache_aw_ready),
    .io_dcache_aw_valid(arb_io_dcache_aw_valid),
    .io_dcache_aw_bits_addr(arb_io_dcache_aw_bits_addr),
    .io_dcache_w_ready(arb_io_dcache_w_ready),
    .io_dcache_w_valid(arb_io_dcache_w_valid),
    .io_dcache_w_bits_data(arb_io_dcache_w_bits_data),
    .io_dcache_w_bits_last(arb_io_dcache_w_bits_last),
    .io_dcache_b_ready(arb_io_dcache_b_ready),
    .io_dcache_b_valid(arb_io_dcache_b_valid),
    .io_dcache_ar_ready(arb_io_dcache_ar_ready),
    .io_dcache_ar_valid(arb_io_dcache_ar_valid),
    .io_dcache_ar_bits_addr(arb_io_dcache_ar_bits_addr),
    .io_dcache_r_ready(arb_io_dcache_r_ready),
    .io_dcache_r_valid(arb_io_dcache_r_valid),
    .io_dcache_r_bits_data(arb_io_dcache_r_bits_data),
    .io_nasti_aw_ready(arb_io_nasti_aw_ready),
    .io_nasti_aw_valid(arb_io_nasti_aw_valid),
    .io_nasti_aw_bits_addr(arb_io_nasti_aw_bits_addr),
    .io_nasti_w_ready(arb_io_nasti_w_ready),
    .io_nasti_w_valid(arb_io_nasti_w_valid),
    .io_nasti_w_bits_data(arb_io_nasti_w_bits_data),
    .io_nasti_w_bits_last(arb_io_nasti_w_bits_last),
    .io_nasti_b_ready(arb_io_nasti_b_ready),
    .io_nasti_b_valid(arb_io_nasti_b_valid),
    .io_nasti_ar_ready(arb_io_nasti_ar_ready),
    .io_nasti_ar_valid(arb_io_nasti_ar_valid),
    .io_nasti_ar_bits_addr(arb_io_nasti_ar_bits_addr),
    .io_nasti_r_ready(arb_io_nasti_r_ready),
    .io_nasti_r_valid(arb_io_nasti_r_valid),
    .io_nasti_r_bits_data(arb_io_nasti_r_bits_data),
    .io_nasti_r_bits_last(arb_io_nasti_r_bits_last)
  );
  MMIO mmio ( // @[Tile.scala 114:31]
    .clock(mmio_clock),
    .reset(mmio_reset),
    .io_cpu_abort(mmio_io_cpu_abort),
    .io_cpu_req_valid(mmio_io_cpu_req_valid),
    .io_cpu_req_bits_addr(mmio_io_cpu_req_bits_addr),
    .io_cpu_req_bits_data(mmio_io_cpu_req_bits_data),
    .io_cpu_req_bits_mask(mmio_io_cpu_req_bits_mask),
    .io_cpu_resp_valid(mmio_io_cpu_resp_valid),
    .io_cpu_resp_bits_data(mmio_io_cpu_resp_bits_data),
    .io_dcache_abort(mmio_io_dcache_abort),
    .io_dcache_req_valid(mmio_io_dcache_req_valid),
    .io_dcache_req_bits_addr(mmio_io_dcache_req_bits_addr),
    .io_dcache_req_bits_data(mmio_io_dcache_req_bits_data),
    .io_dcache_req_bits_mask(mmio_io_dcache_req_bits_mask),
    .io_dcache_resp_valid(mmio_io_dcache_resp_valid),
    .io_dcache_resp_bits_data(mmio_io_dcache_resp_bits_data),
    .io_uart_req_valid(mmio_io_uart_req_valid),
    .io_uart_req_bits_addr(mmio_io_uart_req_bits_addr),
    .io_uart_req_bits_data(mmio_io_uart_req_bits_data),
    .io_uart_resp_valid(mmio_io_uart_resp_valid),
    .io_uart_resp_bits_data(mmio_io_uart_resp_bits_data),
    .io_ledController_req_valid(mmio_io_ledController_req_valid),
    .io_ledController_req_bits_data(mmio_io_ledController_req_bits_data)
  );
  BRAM bram ( // @[Tile.scala 115:31]
    .s_axi_rready(bram_s_axi_rready),
    .s_axi_rvalid(bram_s_axi_rvalid),
    .s_axi_rlast(bram_s_axi_rlast),
    .s_axi_rresp(bram_s_axi_rresp),
    .s_axi_rdata(bram_s_axi_rdata),
    .s_axi_rid(bram_s_axi_rid),
    .s_axi_arready(bram_s_axi_arready),
    .s_axi_arvalid(bram_s_axi_arvalid),
    .s_axi_arburst(bram_s_axi_arburst),
    .s_axi_arsize(bram_s_axi_arsize),
    .s_axi_arlen(bram_s_axi_arlen),
    .s_axi_araddr(bram_s_axi_araddr),
    .s_axi_arid(bram_s_axi_arid),
    .s_axi_bready(bram_s_axi_bready),
    .s_axi_bvalid(bram_s_axi_bvalid),
    .s_axi_bresp(bram_s_axi_bresp),
    .s_axi_bid(bram_s_axi_bid),
    .s_axi_wready(bram_s_axi_wready),
    .s_axi_wvalid(bram_s_axi_wvalid),
    .s_axi_wlast(bram_s_axi_wlast),
    .s_axi_wstrb(bram_s_axi_wstrb),
    .s_axi_wdata(bram_s_axi_wdata),
    .s_axi_awready(bram_s_axi_awready),
    .s_axi_awvalid(bram_s_axi_awvalid),
    .s_axi_awburst(bram_s_axi_awburst),
    .s_axi_awsize(bram_s_axi_awsize),
    .s_axi_awlen(bram_s_axi_awlen),
    .s_axi_awaddr(bram_s_axi_awaddr),
    .s_axi_awid(bram_s_axi_awid),
    .s_aresetn(bram_s_aresetn),
    .s_aclk(bram_s_aclk)
  );
  Uart uart ( // @[Tile.scala 118:31]
    .clock(uart_clock),
    .reset(uart_reset),
    .io_rxd(uart_io_rxd),
    .io_txd(uart_io_txd),
    .io_rxChannel_ready(uart_io_rxChannel_ready),
    .io_rxChannel_valid(uart_io_rxChannel_valid),
    .io_rxChannel_bits(uart_io_rxChannel_bits),
    .io_txChannel_ready(uart_io_txChannel_ready),
    .io_txChannel_valid(uart_io_txChannel_valid),
    .io_txChannel_bits(uart_io_txChannel_bits)
  );
  LEDController ledController ( // @[Tile.scala 119:31]
    .clock(ledController_clock),
    .reset(ledController_reset),
    .io_cpu_req_valid(ledController_io_cpu_req_valid),
    .io_cpu_req_bits_data(ledController_io_cpu_req_bits_data),
    .io_leds(ledController_io_leds)
  );
  UartController uartController ( // @[Tile.scala 120:31]
    .clock(uartController_clock),
    .reset(uartController_reset),
    .io_cpu_req_valid(uartController_io_cpu_req_valid),
    .io_cpu_req_bits_addr(uartController_io_cpu_req_bits_addr),
    .io_cpu_req_bits_data(uartController_io_cpu_req_bits_data),
    .io_cpu_resp_valid(uartController_io_cpu_resp_valid),
    .io_cpu_resp_bits_data(uartController_io_cpu_resp_bits_data),
    .io_rxChannel_ready(uartController_io_rxChannel_ready),
    .io_rxChannel_valid(uartController_io_rxChannel_valid),
    .io_rxChannel_bits(uartController_io_rxChannel_bits),
    .io_txChannel_ready(uartController_io_txChannel_ready),
    .io_txChannel_valid(uartController_io_txChannel_valid),
    .io_txChannel_bits(uartController_io_txChannel_bits)
  );
  assign _T_15 = reset == 1'h0; // @[Tile.scala 146:24]
  assign io_txd = uart_io_txd;
  assign io_ledState = ledController_io_leds;
  assign core_clock = clock;
  assign core_reset = reset;
  assign core_io_icache_resp_valid = icache_io_cpu_resp_valid;
  assign core_io_icache_resp_bits_data = icache_io_cpu_resp_bits_data;
  assign core_io_dcache_resp_valid = mmio_io_cpu_resp_valid;
  assign core_io_dcache_resp_bits_data = mmio_io_cpu_resp_bits_data;
  assign icache_clock = clock;
  assign icache_reset = reset;
  assign icache_io_cpu_abort = 1'h0;
  assign icache_io_cpu_req_valid = core_io_icache_req_valid;
  assign icache_io_cpu_req_bits_addr = core_io_icache_req_bits_addr;
  assign icache_io_cpu_req_bits_data = 32'h0;
  assign icache_io_cpu_req_bits_mask = 4'h0;
  assign icache_io_nasti_aw_ready = 1'h0;
  assign icache_io_nasti_w_ready = 1'h0;
  assign icache_io_nasti_b_valid = 1'h0;
  assign icache_io_nasti_ar_ready = arb_io_icache_ar_ready;
  assign icache_io_nasti_r_valid = arb_io_icache_r_valid;
  assign icache_io_nasti_r_bits_data = arb_io_icache_r_bits_data;
  assign dcache_clock = clock;
  assign dcache_reset = reset;
  assign dcache_io_cpu_abort = mmio_io_dcache_abort;
  assign dcache_io_cpu_req_valid = mmio_io_dcache_req_valid;
  assign dcache_io_cpu_req_bits_addr = mmio_io_dcache_req_bits_addr;
  assign dcache_io_cpu_req_bits_data = mmio_io_dcache_req_bits_data;
  assign dcache_io_cpu_req_bits_mask = mmio_io_dcache_req_bits_mask;
  assign dcache_io_nasti_aw_ready = arb_io_dcache_aw_ready;
  assign dcache_io_nasti_w_ready = arb_io_dcache_w_ready;
  assign dcache_io_nasti_b_valid = arb_io_dcache_b_valid;
  assign dcache_io_nasti_ar_ready = arb_io_dcache_ar_ready;
  assign dcache_io_nasti_r_valid = arb_io_dcache_r_valid;
  assign dcache_io_nasti_r_bits_data = arb_io_dcache_r_bits_data;
  assign arb_clock = clock;
  assign arb_reset = reset;
  assign arb_io_icache_ar_valid = icache_io_nasti_ar_valid;
  assign arb_io_icache_ar_bits_addr = icache_io_nasti_ar_bits_addr;
  assign arb_io_icache_r_ready = icache_io_nasti_r_ready;
  assign arb_io_dcache_aw_valid = dcache_io_nasti_aw_valid;
  assign arb_io_dcache_aw_bits_addr = dcache_io_nasti_aw_bits_addr;
  assign arb_io_dcache_w_valid = dcache_io_nasti_w_valid;
  assign arb_io_dcache_w_bits_data = dcache_io_nasti_w_bits_data;
  assign arb_io_dcache_w_bits_last = dcache_io_nasti_w_bits_last;
  assign arb_io_dcache_b_ready = dcache_io_nasti_b_ready;
  assign arb_io_dcache_ar_valid = dcache_io_nasti_ar_valid;
  assign arb_io_dcache_ar_bits_addr = dcache_io_nasti_ar_bits_addr;
  assign arb_io_dcache_r_ready = dcache_io_nasti_r_ready;
  assign arb_io_nasti_aw_ready = bram_s_axi_awready;
  assign arb_io_nasti_w_ready = bram_s_axi_wready;
  assign arb_io_nasti_b_valid = bram_s_axi_bvalid;
  assign arb_io_nasti_ar_ready = bram_s_axi_arready;
  assign arb_io_nasti_r_valid = bram_s_axi_rvalid;
  assign arb_io_nasti_r_bits_data = bram_s_axi_rdata;
  assign arb_io_nasti_r_bits_last = bram_s_axi_rlast;
  assign mmio_clock = clock;
  assign mmio_reset = reset;
  assign mmio_io_cpu_abort = core_io_dcache_abort;
  assign mmio_io_cpu_req_valid = core_io_dcache_req_valid;
  assign mmio_io_cpu_req_bits_addr = core_io_dcache_req_bits_addr;
  assign mmio_io_cpu_req_bits_data = core_io_dcache_req_bits_data;
  assign mmio_io_cpu_req_bits_mask = core_io_dcache_req_bits_mask;
  assign mmio_io_dcache_resp_valid = dcache_io_cpu_resp_valid;
  assign mmio_io_dcache_resp_bits_data = dcache_io_cpu_resp_bits_data;
  assign mmio_io_uart_resp_valid = uartController_io_cpu_resp_valid;
  assign mmio_io_uart_resp_bits_data = uartController_io_cpu_resp_bits_data;
  assign bram_s_axi_rready = arb_io_nasti_r_ready;
  assign bram_s_axi_arvalid = arb_io_nasti_ar_valid;
  assign bram_s_axi_arburst = 2'h1;
  assign bram_s_axi_arsize = 3'h3;
  assign bram_s_axi_arlen = 8'h1;
  assign bram_s_axi_araddr = arb_io_nasti_ar_bits_addr;
  assign bram_s_axi_arid = 4'h0;
  assign bram_s_axi_bready = arb_io_nasti_b_ready;
  assign bram_s_axi_wvalid = arb_io_nasti_w_valid;
  assign bram_s_axi_wlast = arb_io_nasti_w_bits_last;
  assign bram_s_axi_wstrb = 8'hff;
  assign bram_s_axi_wdata = arb_io_nasti_w_bits_data;
  assign bram_s_axi_awvalid = arb_io_nasti_aw_valid;
  assign bram_s_axi_awburst = 2'h1;
  assign bram_s_axi_awsize = 3'h3;
  assign bram_s_axi_awlen = 8'h1;
  assign bram_s_axi_awaddr = arb_io_nasti_aw_bits_addr;
  assign bram_s_axi_awid = 4'h0;
  assign bram_s_aresetn = _T_15;
  assign bram_s_aclk = clock;
  assign uart_clock = clock;
  assign uart_reset = reset;
  assign uart_io_rxd = io_rxd;
  assign uart_io_rxChannel_ready = uartController_io_rxChannel_ready;
  assign uart_io_txChannel_valid = uartController_io_txChannel_valid;
  assign uart_io_txChannel_bits = uartController_io_txChannel_bits;
  assign ledController_clock = clock;
  assign ledController_reset = reset;
  assign ledController_io_cpu_req_valid = mmio_io_ledController_req_valid;
  assign ledController_io_cpu_req_bits_data = mmio_io_ledController_req_bits_data;
  assign uartController_clock = clock;
  assign uartController_reset = reset;
  assign uartController_io_cpu_req_valid = mmio_io_uart_req_valid;
  assign uartController_io_cpu_req_bits_addr = mmio_io_uart_req_bits_addr;
  assign uartController_io_cpu_req_bits_data = mmio_io_uart_req_bits_data;
  assign uartController_io_rxChannel_valid = uart_io_rxChannel_valid;
  assign uartController_io_rxChannel_bits = uart_io_rxChannel_bits;
  assign uartController_io_txChannel_ready = uart_io_txChannel_ready;
endmodule
