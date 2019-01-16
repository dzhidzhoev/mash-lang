unit u_writers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

procedure St_WriteWord(s: TStream; w: word);
procedure St_WriteCardinal(s: TStream; c: cardinal);
procedure St_WriteInt64(s: TStream; i: int64);
procedure St_WriteDouble(s: TStream; d: double);

implementation

procedure St_WriteWord(s: TStream; w: word);
var 
  i: integer;
begin
  for i := sizeof(w)-1 downto 0 do
  begin
  	s.WriteByte(PByte(@w)[i]);
  end;
end;

procedure St_WriteCardinal(s: TStream; c: cardinal);
var 
  i: integer;
begin
  for i := sizeof(c)-1 downto 0 do
  begin
  	s.WriteByte(PByte(@c)[i]);
  end;
end;

procedure St_WriteInt64(s: TStream; i: int64);
var 
  j: integer;
begin
  for j := sizeof(i)-1 downto 0 do
  begin
  	s.WriteByte(PByte(@i)[j]);
  end;
end;

procedure St_WriteDouble(s: TStream; d: double);
var 
  i: integer;
begin
  for i := sizeof(d)-1 downto 0 do
  begin
  	s.WriteByte(PByte(@d)[i]);
  end;
end;

end.

