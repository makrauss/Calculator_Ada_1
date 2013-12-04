-- stack class specification file

generic
    type DATA_TYPE is private;
    SIZE : positive;

package stack is

-- exceptions
OVERFLOW_ERROR, UNDERFLOW_ERROR : exception;

-- push
procedure Push (DATA : DATA_TYPE);

-- pop
   function Pop return DATA_TYPE;
   --get
   function Get return DATA_TYPE;
   --swap
   procedure Swap;
   --drop
   procedure Drop;

-- empty
procedure Empty;

-- is_empty
function Is_Empty return BOOLEAN;
   -- capacity
   function Capacity return Natural;

end stack;
