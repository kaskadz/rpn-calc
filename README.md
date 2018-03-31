# rpn-calc

Simple Reverse Polish notation calculator.
Basic Erlang module for evaluating RPN expressions.

## Supported operations
Calculator supports following operations:
- +, -, *, / – basic arithmetic operations
- pow – power
- sqrt – square root
- sin, cos, tan, cot – basic trigonometric functions
- ceil, floor – truncating operations
- pop – remove top of the stack
- ps – print stack
- v, verbose - verbosity mode

_Unknown and umnached operations are ignored._

## Usage examples
```erlang
rpn_calc:rpn("5 6 3 pow 4 / - sqrt").
```

7.0

```erlang
rpn_calc:rpn("1 2 3 4 5 pop + + sqrt sqrt").
```

1.7320508075688772

```erlang
`rpn_calc:rpn("1 2 3 4 5 pop + + sqrt sqrt ceil").
```

2.0

```erlang
rpn_calc:rpn("1 2 3 4 5 pop * * ps -").
```
> \>-|1, 24, |--

-23

```erlang
rpn_calc:rpn("1 2 3 4 5 pop * * ps - v").
```
> Input: 1, 2, 3, 4, 5, pop, *, *, ps, -,
>
> \>-|1, 24, |--
>
> Output: -23

-23
