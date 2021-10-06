# Arithmetic and Logical Operations in Assembly Language.

## The `lea` Instruction.

|Instruction            |       Effect          |              Description|
|:---                   |       :---:           |                     ---:|
|`leaq S, D`            |       `D = &S`        |   Load Effective Address|
|`inc D`                |       `D += 1`        |   Increment             |
|`dec D`                |       `D -= 1`        |   Decrement             |
|`not D`                |       `D = ~D`        |   Negate                |
|`add S, D`             |       `D = D+S`       |   Add                   |
|`sub S, D`             |       `D = D-S`       |   Subtract              |
|`imul S, D`            |       `D = D*S`       |   Multiply              |
|`xor S, D`             |       `D = D^S`       |   Exclusive Or          |
|`or S, D`              |       `D = D|S`       |   Or                    |
|`and S, D`             |       `D = D&S`       |   And                   |
|`sal k, D`             |       `D =  << k`     |   Left Shift            |
|`shl k, D`             |       `D =  << k`     |   Left Shift            |
|`sar k, D`             |       `D =  >> k`     |   Arithmetic Right Shift|
|`shl k, D`             |       `D =  >> k`     |   Logical Right Shift   |
