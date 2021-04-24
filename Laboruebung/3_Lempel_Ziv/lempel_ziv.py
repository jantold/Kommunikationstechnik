import math
from threading import Thread, Lock

bestLock = Lock()
plotLock = Lock()

best_bits_rueckwertsref = 0
best_bits_laenge_zeichenkette = 0
best_bitstring_length = 0
# bits_rueckwertsref, bits_laenge_zeichenkette, bitstring_length
surface_plot = [[], [], []]


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


def threading(content, bits_rueckwertsref, bits_laenge_zeichenkette):
    global surface_plot
    global best_bits_rueckwertsref
    global best_bits_laenge_zeichenkette
    global best_bitstring_length

    list_tuple, bitstring, alphabet = lempel_ziv_encode(
        content, bits_rueckwertsref, bits_laenge_zeichenkette)

    # decode
    # print(lempel_ziv_decode(bitstring, list_tuple,
    #                         bits_rueckwertsref, bits_laenge_zeichenkette, alphabet))

    # bit-length - only lempel_ziv
    # only lempel-ziv -----
    bitstring_length = len(list_tuple) * bits_rueckwertsref + \
        len(list_tuple) * bits_laenge_zeichenkette + \
        len(list_tuple) * bits_per_char

    plotLock.acquire()

    surface_plot[0].append(bits_rueckwertsref)
    surface_plot[1].append(bits_laenge_zeichenkette)
    surface_plot[2].append(bitstring_length)

    plotLock.release()

    # print('len:', bitstring_length)
    if bitstring_length <= best_bitstring_length:
        bestLock.acquire()

        best_bitstring_length = bitstring_length
        best_bits_rueckwertsref = bits_rueckwertsref
        best_bits_laenge_zeichenkette = bits_laenge_zeichenkette

        bestLock.release()


with open('rfc2795.txt') as f:
    bits_per_char = 7
    content = f.readlines()

    # content = "BANANENANBAU"
    # content = "FISCHERSFRITZFISCHTFRISCHEFISCHE"
    content = ''.join(content)
    best_bits_rueckwertsref = 0
    best_bits_laenge_zeichenkette = 0
    best_bitstring_length = math.inf
    max_len = math.ceil(math.log2(len(content))) + 1

    threads = []
    for bits_rueckwertsref in range(1, max_len):

        # bits fuer zeichenkette <= bits_rueckwertsref
        for bits_laenge_zeichenkette in range(1, bits_rueckwertsref+1):

            t = Thread(target=threading, args=(
                content, bits_rueckwertsref, bits_laenge_zeichenkette))
            t.start()
            threads.append(t)

    for t in threads:
        t.join()

print('only lempel-ziv best combination -----')
print('bitstring_length:', best_bitstring_length)
print('bits_rueckwertsref:', best_bits_rueckwertsref)
print('bits_laenge_zeichenkette:', best_bits_laenge_zeichenkette)

# print("content")
# print(tobits('3'))
# print(frombits(tobits('3'), bits_count=6))


print(surface_plot)
