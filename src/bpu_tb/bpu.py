import bpu_utils as u

# Function definitions


def predict(pc):
    pred = u.Prediction()
    pred.pc = pc
    pred.index = history.bht ^ history.get_index(pc)
    btb_result = btb.query(pc)
    pred.target = btb_result[1]
    pred.taken = pht.query(pred.index) and btb_result[0]
    return pred


def resolve(res):
    if res.valid:
        history.shift(res.taken)
        pht.update(res.index, res.taken)
        if res.mispredict:
            btb.update(res.pc, res.target, not res.taken)


# Define structures
history = u.History()
pht = u.Pht()
btb = u.Btb()

res = u.Resolution(True, 10, 0, 15, True, True)
resolve(res)

print(history)
print(btb.query(10))
