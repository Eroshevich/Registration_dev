import random
import hashlib
import hmac
import secrets

g = ('rock', 'paper', 'scissors')

while True:
    key = secrets.token_hex(16)
    comp = random.randint(0, 2)
    computer_choice = g[comp]
    print ("\n Computer choice: ")
    print(hmac.new(bytes(key, "utf-8"), bytes(computer_choice, "utf-8"), hashlib.sha256).digest())
    knb = int(input('Rock(1), paper(2) or scissors(3)? ')) - 1
    print(" You chooses {}, computer chooses {}.\n{}".format(g[knb], g[comp],
        ('You lose!', 'Tie!', 'You win!')[((comp + 1) % len(g)) - knb]))

    print("Key: ", key)
