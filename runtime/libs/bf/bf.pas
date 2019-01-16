library bf;

uses SysUtils, svm_api in '..\svm_api.pas';

procedure DHalt(Stack:PStack); cdecl;
begin
  halt;
end;

procedure DStrToInt(Stack:PStack); cdecl;
var
  s:string;
begin
  s := TSVMMem(Stack^.popv).GetS;
  Stack^.push(TSVMMem.CreateF(StrToInt(s), svmtInt));
end;

procedure DStrToFloat(Stack:PStack); cdecl;
var
  s:string;
  f:double;
begin
  s := TSVMMem(Stack^.popv).GetS;
  f := StrToFloat(s);
  Stack^.push(TSVMMem.CreateF(f, svmtReal));
end;

procedure DStrUpper(Stack:PStack); cdecl;
var
  s:string;
begin
  s := TSVMMem(Stack^.popv).GetS;
  Stack^.push(TSVMMem.CreateFS(UpperCase(s)));
end;

procedure DStrLower(Stack:PStack); cdecl;
var
  s:string;
begin
  s := TSVMMem(Stack^.popv).GetS;
  Stack^.push(TSVMMem.CreateFS(LowerCase(s)));
end;

procedure DIntToStr(Stack:PStack); cdecl;
var
  s:int64;
begin
  s := TSVMMem(Stack^.popv).GetI;
  Stack^.push(TSVMMem.CreateFS(IntToStr(s)));
end;

procedure DFloatToStr(Stack:PStack); cdecl;
var
  s:double;
begin
  s := TSVMMem(Stack^.popv).GetD;
  Stack^.push(TSVMMem.CreateFS(FloatToStr(s)));
end;

procedure DSleep(Stack:PStack); cdecl;
begin
  sleep(TSVMMem(Stack^.popv).GetW);
end;

//DateTime
procedure DNow(Stack:PStack); cdecl;
var
  f:double;
begin
  f := now;
  Stack^.push(TSVMMem.CreateF(f, svmtReal));
end;

procedure DRandomize(Stack:PStack); cdecl;
begin
  Randomize;
end;

procedure DRandom(Stack:PStack); cdecl;
var
  f:double;
begin
  f := Random;
  Stack^.push(TSVMMem.CreateF(f, svmtReal));
end;

procedure DRandomB(Stack:PStack); cdecl;
var
  f:double;
begin
  f := Random(TSVMMem(Stack^.popv).GetW);
  Stack^.push(TSVMMem.CreateF(f, svmtReal));
end;

procedure DTickCnt(Stack:PStack); cdecl;
begin
  Stack^.push(TSVMMem.CreateFW(GetTickCount64));
end;

const
  ExportedSymbolNamePrefix = {$ifdef Darwin}'_'{$else}''{$endif};

{EXPORTS DB}
exports DINTTOSTR           name ExportedSymbolNamePrefix + 'INTTOSTR';
exports DFLOATTOSTR         name ExportedSymbolNamePrefix + 'FLOATTOSTR';
exports DSTRTOINT           name ExportedSymbolNamePrefix + 'STRTOINT';
exports DSTRTOFLOAT         name ExportedSymbolNamePrefix + 'STRTOFLOAT';
exports DHALT               name ExportedSymbolNamePrefix + 'HALT';
exports DSLEEP              name ExportedSymbolNamePrefix + 'SLEEP';
exports DSTRUPPER           name ExportedSymbolNamePrefix + 'STRUPPER';
exports DSTRLOWER           name ExportedSymbolNamePrefix + 'STRLOWER';
exports DNOW                name ExportedSymbolNamePrefix + 'CURRENTDATETIME';
exports DRANDOMIZE          name ExportedSymbolNamePrefix + 'RANDOMIZE';
exports DRANDOM             name ExportedSymbolNamePrefix + 'RANDOM';
exports DRANDOMB            name ExportedSymbolNamePrefix + 'RANDOMB';
exports DTICKCNT            name ExportedSymbolNamePrefix + 'TICKCNT';

begin
end.
