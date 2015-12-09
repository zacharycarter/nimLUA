import nimLUA, os, strutils

type
  GENE {.pure.} = enum
    ADENINE, CYTOSINE, GUANINE, THYMINE
  
  ATOM = enum
    ELECTRON, PROTON, NEUTRON
    
  FRUIT = enum
    APPLE, BANANA, PEACH, PLUM
    
  `poncho` = enum
    `glucho`, `becho`
 
const
  MANGOES = 10.0
  PAPAYA = 11.0'f64
  LEMON = 12.0'f32
  MAX_DASH_PATTERN = 8
  CATHODE = 10'u8
  ANODE = 11'i8
  ELECTRON16 = 12'u16
  PROTON16 = 13'i16
  ELECTRON32 = 14'u32
  PROTON32 = 15'i32
  ELECTRON64 = 16'u64
  PROTON64 = 17'i64
  LABEL_STYLE_CH = ["D", "R", "r", "A", "a"]
  INFO_FIELD = ["Creator", "Producer", "Title", "Subject", "Author", "Keywords"]
  STAIR = [123, 456]
  HELIX = [123.4, 567.8]
  GREET = "hello world"
  connected = true
  mime = {
    "apple": "fruit",
    "men": "woman"
  }
  
  programme = {
    1: "state",
    2: "power",
    3: "result"
  }
  
proc addv(a: seq[int]): int = 
  result = 0
  for k in a:
    result += k
    
proc mulv(a,b:int): int = a * b

proc tpc(s: string): string = 
  result = s

proc tpm(s: string, v: string): string = 
  result = s & " " & v

proc rootv(u: float): seq[int] =
  result = newSeq[int](10)
  for i in 0..9: result[i] = int(u * i.float)
  
proc test(L: PState, fileName: string) =
  if L.doFile("test" & DirSep & fileName) != 0.cint:
    echo L.toString(-1)
    L.pop(1)
    doAssert false
  else:
    echo fileName & " .. OK"
  
proc `++`(a, b: int): int = a + b

type
  Foo = ref object
    name: string

proc newFoo(name: string): Foo =
  new(result)
  result.name = name

proc newFoo(a, b: int): Foo =
  new(result)
  result.name = $a & $b
  
proc addv(f: Foo, a, b: int): int =
  result = 2 * (a + b)

proc addv(f: Foo, a, b: string): string =
  result = "hello: my name is $1, here is my message: $2, $3" % [f.name, a, b]
  
proc addk(f: Foo, a, b: int): string =
  result = f.name & ": " & $a & " + " & $b & " = " & $(a+b)

proc machine(a, b: int): int =
  result = a + b
  
proc machine(a: int): int =
  result = a * 3
  
proc machine(a: int, b:string): string =
  result = b & $a
  
proc machine(a,b,c:string): string =
  result = a & b & c

proc main() =
  var L = newNimLua()
  #nimLuaDebug(true)
  
  L.bindEnum(GENE)
  L.test("single_scoped_enum.lua")
  
  L.bindEnum(GENE -> "DNA", ATOM -> GLOBAL, FRUIT) 
  L.test("scoped_and_global_enum.lua")

  L.bindEnum:
    ATOM
    GENE
    FRUIT
    `poncho`
  L.test("scoped_enum.lua")
  
  L.bindFunction(mulv, tpc, tpm -> "goodMan")
  L.test("free_function.lua")
  
  L.bindFunction("gum"):
    mulv
    tpc    
    tpm -> "goodMan"
    `++`
  L.test("scoped_function.lua")  
  
  L.bindConst:
    MANGOES
    PAPAYA
    LEMON
    MAX_DASH_PATTERN
    CATHODE
    ANODE
    
  L.bindConst("mmm"):
    ELECTRON16
    PROTON16
    ELECTRON32
    PROTON32
    ELECTRON64
    PROTON64
    connected
    
  L.bindConst("ccc"):
    LABEL_STYLE_CH
    INFO_FIELD
    STAIR
    HELIX
    GREET
    mime
    programme

  L.bindConst:
    MANGOES -> "MANGGA"
    PAPAYA -> "PEPAYA"
    LEMON -> "JERUK"
    
  L.bindConst("buah"):
    MANGOES -> "MANGGA"
    PAPAYA -> "PEPAYA"
    LEMON -> "JERUK"
    
  L.test("constants.lua")  
    
  L.bindObject(Foo):
    newFoo -> constructor
    addv
    addk -> "add"
    
  L.test("fun.lua")
    
  L.bindFunction("mac"):
    machine
  L.test("ov_func.lua")
  
  L.close()
  
main()