import math


def tobits(s):
    result = []
    for c in s:
        if c.isnumeric():
            print("true")
            c = int(c)
        bits = bin(ord(c))[2:]
        bits = '000000'[len(bits):] + bits
        result.extend([int(b) for b in bits])
    return result


def frombits(bits, bits_count=8):
    chars = []
    for b in range(len(bits) // bits_count):
        byte = bits[b*bits_count:(b+1)*bits_count]
        chars.append(chr(int(''.join([str(bit) for bit in byte]), 2)))
    return ''.join(chars)


def lempel_ziv_encode(zeichenkette, bits_rueckwertsref, bits_laenge_zeichenkette):
    zeichenkette = zeichenkette.lower()
    max_rueck = 2 ** bits_rueckwertsref

    list_tuple = []
    i = 0
    while i < len(zeichenkette):
        tmp = i-max_rueck if i-max_rueck >= 0 else 0
        possible_back_string = zeichenkette[tmp: i]
        add = (0, 0, zeichenkette[i])

        for j in range(bits_laenge_zeichenkette):
            tmp = j + 1
            x = possible_back_string.rfind(zeichenkette[i:i+tmp])
            if x == -1 or len(zeichenkette) < i+j:
                i += j
                break

            add = (len(possible_back_string) - x, tmp if len(zeichenkette) > i+tmp else j,
                   zeichenkette[i + tmp] if len(zeichenkette) > i+tmp else '')

        list_tuple.append(add)
        i += 1

    # Alphabet (Zeichen, die in der Zeichenkette vorkommen)
    return list_tuple, ''.join(format(ord(i), '08b') for i in zeichenkette), ''.join(set(zeichenkette))


def lempel_ziv_decode(bitstring, list_tuple, bits_rueckwertsref, bits_laenge_zeichenkette, alphabet):
    string = frombits(bitstring)
    # if bitstring is given -> convert tuple_list

    ret = ''
    for back, length, next_char in list_tuple:
        middle = ret[len(ret) - back: len(ret) - back + length]
        ret += middle + next_char

    return ret


test = "BANANENANBAU"
# test = "FISCHERSFRITZFISCHTFRISCHEFISCHE"
list_tuple, bitstring, alphabet = lempel_ziv_encode(test, 3, len(test))
for i in list_tuple:
    print(i)

print("Bitstring:", bitstring)
print("Alphabet:", alphabet)


print(lempel_ziv_decode(bitstring, list_tuple, 3, len(test), alphabet))

print("test")
print(tobits('3'))
print(frombits(tobits('3'), bits_count=6))
