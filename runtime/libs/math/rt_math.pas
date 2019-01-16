library rt_math;

{$mode objfpc}

uses math, svm_api in '..\svm_api.pas';

procedure FSin(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(sin(TSVMMem(Stack^.popv).GetD));
end;

procedure FCos(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(cos(TSVMMem(Stack^.popv).GetD));
end;

procedure FTg(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(tan(TSVMMem(Stack^.popv).GetD));
end;

procedure FCtg(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(cotan(TSVMMem(Stack^.popv).GetD));
end;

procedure FArcSin(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(ArcSin(TSVMMem(Stack^.popv).GetD));
end;

procedure FArcCos(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(ArcCos(TSVMMem(Stack^.popv).GetD));
end;

procedure FLog10(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(Log10(TSVMMem(Stack^.popv).GetD));
end;

procedure FLog2(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(Log2(TSVMMem(Stack^.popv).GetD));
end;

procedure FLogN(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(LogN(TSVMMem(Stack^.popv).GetD, TSVMMem(Stack^.popv).GetD));
end;

procedure Flnxp1(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(lnxp1(TSVMMem(Stack^.popv).GetD));
end;

procedure FExp(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.Create);
  TSVMMem(Stack^.peek).SetD(Exp(TSVMMem(Stack^.popv).GetD));
end;

const
  ExportedSymbolNamePrefix = {$ifdef Darwin}'_'{$else}''{$endif};
  
{EXPORTS}
exports FSIN     name ExportedSymbolNamePrefix + 'RT_SIN';
exports FCOS     name ExportedSymbolNamePrefix + 'RT_COS';
exports FTG      name ExportedSymbolNamePrefix + 'RT_TG';
exports FCTG     name ExportedSymbolNamePrefix + 'RT_CTG';
exports FARCSIN  name ExportedSymbolNamePrefix + 'RT_ARCSIN';
exports FARCCOS  name ExportedSymbolNamePrefix + 'RT_ARCCOS';
exports FLOG10   name ExportedSymbolNamePrefix + 'RT_LOG10';
exports FLOG2    name ExportedSymbolNamePrefix + 'RT_LOG2';
exports FLOGN    name ExportedSymbolNamePrefix + 'RT_LOGN';
exports FLNXP1   name ExportedSymbolNamePrefix + 'RT_LNXP1';
exports FExp     name ExportedSymbolNamePrefix + 'RT_EXP';

begin
end.
