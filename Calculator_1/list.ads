generic
  type DATA_TYPE is private;
  type ID_TYPE is private;

package list is

  -- exceptions
  ITEM_NOT_FOUND : exception;

  -- PushList
  procedure Add (ID : ID_TYPE; VALUE : DATA_TYPE);

  -- PopList
  function Get (ID : ID_TYPE) return DATA_TYPE;

  -- SearchList
  function Search (ID : ID_TYPE) return BOOLEAN;

end list;
