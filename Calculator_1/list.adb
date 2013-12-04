package body list is

-- declarations
type NODE;                                        -- single node
type NODE_POINTER is access NODE;                -- node pointer
type NODE is                                        -- node structure
  record
    NEXT         : NODE_POINTER;
    ID                : ID_TYPE;
    VALUE        : DATA_TYPE;
  end record;
FIRST_NODE         : NODE_POINTER        := null;        -- first node declaration

procedure Add (ID : ID_TYPE; VALUE : DATA_TYPE) is                 -- add data to list
  NEW_NODE         : NODE_POINTER         := NEW NODE' (NEXT => FIRST_NODE, ID => ID, VALUE => VALUE);
  begin
    FIRST_NODE         := NEW_NODE;
end Add;

function Get (ID : ID_TYPE) return DATA_TYPE is        -- return DATA_TYPE --pops data from list
  THIS_NODE         : NODE_POINTER         := FIRST_NODE;
  begin
    while THIS_NODE /= null loop
      if THIS_NODE.ID = ID then
            return THIS_NODE.VALUE;
      end if;
      THIS_NODE := THIS_NODE.NEXT;
    end loop;
    raise ITEM_NOT_FOUND;
end Get;

function Search (ID : ID_TYPE) return BOOLEAN is -- searches list for specific id
  THIS_NODE        : NODE_POINTER        := FIRST_NODE;
  begin
    while THIS_NODE /= null loop
      if THIS_NODE.ID         = ID then
        return true;
      end if;
      THIS_NODE                := THIS_NODE.NEXT;
    end loop;
    return FALSE;
end Search;

end list;
