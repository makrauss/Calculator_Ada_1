with Ada.Text_IO,
     Ada.Strings.Unbounded,
    Ada.Numerics.Generic_Elementary_Functions,        -- math functions library
    stack,                                        -- my class implementation
    list;                                        -- my class implementation

use Ada.Text_IO,
    Ada.Strings.Unbounded,
    Ada.Numerics;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

procedure calculator is

-- subtypes
type VAL_TYPE is digits 10;

-- IO
package VAL_TYPE_IO is
new FLOAT_IO (VAL_TYPE);
use VAL_TYPE_IO;

-- packages
package VAL_TYPE_FUNCTIONS is
new Generic_Elementary_Functions (VAL_TYPE);
use VAL_TYPE_FUNCTIONS;
package Value_Stack is new Stack(VAL_TYPE, 64);
use Value_Stack;

-- exceptions
SYNTAX_ERROR                 : exception;
DIVIDE_BY_ZERO                : exception;
No_Expression_Error : exception;
   function Calculate return VAL_TYPE is
      type Token_Type is
        ('+','-','*','/','$', Number, End_Of_Line);
      package Token_Stack is new Stack (Token_Type, 10);

      Token: Token_Type;
      Value: Val_Type;
      ID, Last_Identifier : Unbounded_String;

      function Get_Token return Token_Type is
         EOL : Boolean;
         C : Character;

         function Is_Space (C: Character) return Boolean is
         begin
            return C = HT or else C = Space;
         end Is_Space;

         function Is_Digit (C: Character) return Boolean is
         begin
            case C is
               when '0'..'9' =>
                  return true;
               when others =>
                  return false;
            end case;
         end Is_Digit;

      begin -- get_token
         if not Token_Stack.Is_Empty then
            return Token_Stack.Pop;
         end if;

         loop
            Look_Ahead (C, EOL);
            if EOL then
               return End_Of_Line;
            end if;
            exit when not Is_Space(C);
            Get (C);
         end loop;

         case C is
            when '+' =>
               Get(C);
               return '+';
            when '-' =>
               Get(C);
               return '-';
            when '*' =>
               Get(C);
               return '*';
            when '/' =>
               Get(C);
               return '/';
              when '0' .. '9' =>
                  begin
                     Get (Value);
                     return Number;
                  exception
                     when others =>
                        raise Syntax_Error;
                  end;
               when others =>
                  raise Syntax_Error;
         end case;

      end Get_Token;
     procedure Parse_Expr0 is
      procedure Parse_Expr1 is
         procedure Parse_Expr2 is
            procedure Parse_Expr3 is
               begin --parse_expr3
                  Token := Get_Token;
                  case Token is
                     when Number =>
                        Push(Value);
                     when '+' =>
                        Parse_Expr3;
                     when '-' =>
                        Parse_Expr3;
                        Push(-Pop);
                     when others =>
                        Token_Stack.Push (Token);
                  end case;
            end Parse_Expr3;

            Divisor : VAL_TYPE;

         begin--parse_expr2
            Parse_Expr3;
            loop
               Token := Get_Token;
               case Token is
                  when '*' =>
                     Parse_Expr3;
                     Push (Pop * Pop);
                  when '/' =>
                     Parse_Expr3;
                     Divisor := Pop;
                     if Divisor = VAL_TYPE (0) then
                        raise DIVIDE_BY_ZERO;
                     else
                        Push (Pop / Divisor);
                     end if;
                  when others =>
                     Token_Stack.Push (Token);
                     exit;
               end case;
            end loop;
         end Parse_Expr2;

      begin --Parse_Expr1
         Parse_Expr2;
         loop
            Token := Get_Token;
            case Token is
               when '+' =>
                  Parse_Expr2;
                  Push (Pop + Pop);
               when '-' =>
                  Parse_Expr2;
                  Swap;
                  Push (Pop -Pop);
               when others =>
                  Token_Stack.Push (Token);
                  exit;
            end case;
         end loop;
      end Parse_Expr1;

   begin -- parse_expr0
      Token:= Get_Token;
      if Token = '$' then
         Last_Identifier := ID;
         Parse_Expr1;
         return;
      else
         Token_Stack.Push(Token);
      end if;
      Parse_Expr1;
   end Parse_Expr0;



begin
  --body of calculator
   Parse_Expr0;
   Skip_Line;
   case Capacity is
      when 0 =>
         raise No_Expression_Error;
      when 1 =>
         return Pop;
      when others =>
         raise SYNTAX_ERROR;
   end case;
exception
   when No_Expression_Error =>
      raise;
   when others =>
      Skip_Line;
      raise;
   end Calculate;

    procedure Put_Adaptive (X : Val_Type) is

      S : String (1 .. 80);
      First : Positive := S'First;
      Last : Positive := S'Last;

   begin -- Put_Adaptive
      Put (To => S, Item => X, Aft => Val_Type'Digits, Exp => 0);
      while S (First) = ' ' loop
         First := First + 1;
      end loop;
      while S (Last) = '0' loop
         Last := Last - 1;
      end loop;
      if S (Last) = '.' then
         Last := Last - 1;
      end if;
      Put (S (First .. Last));
   end Put_Adaptive;
begin --Calculator
   loop
      declare
         Result: VAL_TYPE;
      begin
         Put("? ");
         Result := Calculate;
         Put("= ");
         Put_Adaptive(Result);
         New_Line;
      end;
   end loop;

end calculator;
