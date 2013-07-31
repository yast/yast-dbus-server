# encoding: utf-8

# This is a testing module for the YaST DBuse service
# Some methods are not called during tests, but the correct signature is checked in the introspection test
require "yast"

module Yast
  class TESTClass < Module
    def List
      []
    end

    def ListAny
      []
    end

    def ListAny1
      [1, "string"]
    end

    def ListAny2
      [["dssd", 123], ["zxcxczzx", 456]]
    end

    def ListString
      ["dssd", "sdfdfs"]
    end

    def ListListString
      [["dssd", "sdfdfs"], ["zxcxczzx"]]
    end

    def ListMap
      []
    end

    def ListMapStringString
      []
    end

    def ListMapStringAny
      [{ "a" => "b" }, { "c" => [10, 20, "haha", :Symbol] }]
    end

    def MapStringAny
      {}
    end

    def MapStringString
      {}
    end

    def MapStringListString
      {}
    end

    def String
      "a"
    end

    def Any
      "a"
    end

    def Any2
      ["a"]
    end

    def Integer
      10
    end

    def Symbol
      :s
    end

    def MapAny
      {}
    end

    def MapAny2
      { "3" => "l" }
    end

    def MapAny3
      { "3" => ["l", "3"] }
    end

    def MapAny4
      { "3" => { "l" => ["3", 10, { "a" => "b" }] } }
    end

    # Note: interger key is returned as string in map<any,X> type,
    # map<interger,X> must be used to return int,
    # Dbus requires a basic type as key, a variant cannot be sent
    def MapAny5
      { 3 => 4, "4" => "5" }
    end

    def Void
      nil
    end

    # ParamFoo: test DBus->YCP conversion
    def ParamAny(p)
      p = deep_copy(p)
      deep_copy(p)
    end

    #Valid YCP but useless
    #global define any ParamVoid(void p)
    #{return p;}

    def ParamBoolean(p)
      p
    end

    def ParamInteger(p)
      p
    end

    def ParamFloat(p)
      p = deep_copy(p)
      deep_copy(p)
    end

    def ParamString(p)
      p
    end

    def ParamLocale(p)
      p = deep_copy(p)
      deep_copy(p)
    end

    def ParamByteblock(p)
      p = deep_copy(p)
      deep_copy(p)
    end

    def ParamPath(p)
      p
    end

    def ParamSymbol(p)
      p
    end

    def ParamList(p)
      p = deep_copy(p)
      deep_copy(p)
    end

    # FIXME this fails, expecting a plain string
    #global define any ParamTerm(term p)
    #{return p;}

    # inconsistent name, the first test
    def ParamMap(p)
      p = deep_copy(p)
      deep_copy(p)
    end

    def ParamMapA(p)
      p = deep_copy(p)
      deep_copy(p)
    end

    def ParamBlock(p)
      p = deep_copy(p)
      deep_copy(p)
    end

    publish :function => :List, :type => "list ()"
    publish :function => :ListAny, :type => "list ()"
    publish :function => :ListAny1, :type => "list ()"
    publish :function => :ListAny2, :type => "list ()"
    publish :function => :ListString, :type => "list <string> ()"
    publish :function => :ListListString, :type => "list <list <string>> ()"
    publish :function => :ListMap, :type => "list <map> ()"
    publish :function => :ListMapStringString, :type => "list <map <string, string>> ()"
    publish :function => :ListMapStringAny, :type => "list <map <string, any>> ()"
    publish :function => :MapStringAny, :type => "map <string, any> ()"
    publish :function => :MapStringString, :type => "map <string, string> ()"
    publish :function => :MapStringListString, :type => "map <string, list <string>> ()"
    publish :function => :String, :type => "string ()"
    publish :function => :Any, :type => "any ()"
    publish :function => :Any2, :type => "any ()"
    publish :function => :Integer, :type => "integer ()"
    publish :function => :Symbol, :type => "symbol ()"
    publish :function => :MapAny, :type => "map ()"
    publish :function => :MapAny2, :type => "map ()"
    publish :function => :MapAny3, :type => "map ()"
    publish :function => :MapAny4, :type => "map ()"
    publish :function => :MapAny5, :type => "map ()"
    publish :function => :Void, :type => "void ()"
    publish :function => :ParamAny, :type => "any (any)"
    publish :function => :ParamBoolean, :type => "any (boolean)"
    publish :function => :ParamInteger, :type => "any (integer)"
    publish :function => :ParamFloat, :type => "any (float)"
    publish :function => :ParamString, :type => "any (string)"
    publish :function => :ParamLocale, :type => "any (locale)"
    publish :function => :ParamByteblock, :type => "any (byteblock)"
    publish :function => :ParamPath, :type => "any (path)"
    publish :function => :ParamSymbol, :type => "any (symbol)"
    publish :function => :ParamList, :type => "any (list)"
    publish :function => :ParamMap, :type => "any (map <string, any>)"
    publish :function => :ParamMapA, :type => "any (map)"
    publish :function => :ParamBlock, :type => "any (block <any>)"
  end

  TEST = TESTClass.new
end
