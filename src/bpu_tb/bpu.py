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

# Read resolutions file
with open('bpu_resolutions.txt', 'r') as res_file:
    for line in enumerate(res_file):
        resolve(u.res_parser(line[1].strip()))

# Output predictions
with open('bpu_predictions.txt', 'w') as pred_file:
    for i in range(32):
        pred_file.write(f'{str(predict(12))}\n')
