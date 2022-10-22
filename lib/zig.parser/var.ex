defmodule Zig.Parser.Var do
  @enforce_keys [:name, :line, :column]
  defstruct @enforce_keys ++
              [
                :doc_comment,
                :type,
                :align,
                :linksection,
                :value,
                extern: false,
                export: false,
                pub: false,
                threadlocal: false
              ]

  def from_args([name | rest], position) when is_binary(name) do
    decorate(
      %__MODULE__{name: String.to_atom(name), line: position.line, column: position.column},
      rest
    )
  end

  defp decorate(var, [:COLON, type | rest]) do
    var
    |> struct(type: type)
    |> decorate(rest)
  end

  defp decorate(var, [:EQUAL, value | rest]) do
    var
    |> struct(value: value)
    |> decorate(rest)
  end

  defp decorate(var, [:linksection, :LPAREN, section, :RPAREN | rest]) do
    var
    |> struct(linksection: section)
    |> decorate(rest)
  end

  defp decorate(var, [:align, :LPAREN, align, :RPAREN | rest]) do
    var
    |> struct(align: align)
    |> decorate(rest)
  end

  defp decorate(var, [:SEMICOLON]), do: var
end
