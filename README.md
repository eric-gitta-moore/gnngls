1、LKH-3 依赖
```sh
wget http://akira.ruc.dk/~keld/research/LKH-3/LKH-3.0.6.tgz
tar xvfz LKH-3.0.6.tgz
cd LKH-3.0.6
make
# sudo cp LKH /usr/local/bin
export PATH=`pwd`:$PATH
```

2、本项目依赖
```sh
git submodule init
git submodule update

pip insatll uv
uv sync
export PYTHONPATH=`pwd`
```

3、pyconcorde 依赖（macOS 15,8 完美运行，不用任何处理）
```sh
cd external/pyconcorde
uv pip install -e .
```

需要过程和结果数据直接拉 docker 自取
```sh
docker run -it --rm ghcr.io/eric-gitta-moore/gnngls-test:train-data /bin/bash
```

```diff
scripts
├── 4b02e2042.res
├── O4b02e2042.res
+├── data
│   ├── 0017cba6fcf341b98031422b336695af.pkl
│   ├── 0018cf4b489a43e0aa42491fd3ec9bec.pkl
│   ├── 016e6746fc3b406499897499fc7b1274.pkl
│   ├── 0265aad0ef8446949b91598d61286887.pkl
│   ├── 0282ab6be4c242cab16f766771ce361b.pkl
│   ├── ...
+│   ├── scalers.pkl
+│   ├── test.txt
+│   ├── train.txt
+│   └── val.txt
├── generate_instances.py
├── models
+│   ├── May02_17-56-50_ee90404d960d414294ad360db5764202
+│   │   ├── checkpoint_best_val.pt
+│   │   ├── checkpoint_final.pt
+│   │   ├── events.out.tfevents.1746179810.LXMW72K6MW.59995.0
+│   │   └── params.json
│   └── tsp20
│       ├── checkpoint_best_val.pt
│       └── params.json
├── preprocess_dataset.py
+├── runs
+│   └── May02_19-38-47_dec0554837bb4860ae1cd2a72026385d.pkl
├── test.py
└── train.py

6 directories, 517 files
```

---

# Graph Neural Network Guided Local Search for the Traveling Salesperson Problem

Code accompanying the paper [Graph Neural Network Guided Local Search for the Traveling Salesperson Problem](https://arxiv.org/abs/2110.05291).

Want to skip straight to [the example](https://github.com/proroklab/gnngls#minimal-example)?

## Setup
We uploaded the test datasets and models using [git lfs](https://git-lfs.github.com/). You must install it to clone the repo correctly.

1. Install [git lfs](https://git-lfs.github.com/)
2. Install [pipenv](https://pipenv.pypa.io)
3. Clone the repo
4. Navigate to the repo and run `pipenv install` in the root directory
5. Run `pipenv shell` to activate the environment

## Datasets
The test datasets used in the paper are found in [data](https://github.com/proroklab/gnngls/tree/master/data).

You can also generate new datasets in two steps: instance generation and preprocessing. You can generate solved TSP instances using:
```
./generate_instances.py <number of instances to generate> <number of nodes> <dataset directory>
```

The specified directory is created. Each instance is a pickled `networkx.Graph`.

Then, prepare the dataset using:
```
./preprocess_dataset.py <dataset directory>
```
This splits the dataset into training, validation, and test sets written to `train.txt`, `val.txt`, and `test.txt` respectively. It also fits a scaler to the training set.

After this step, the datasets can be easily manipulated using `gnngls.TSPDataset`. For example, in [train.py](https://github.com/ben-hudson/gnngls/blob/master/scripts/train.py#L89).

## Training
Train the model using:
```
./train.py <dataset directory> <tensorboard directory> --use_gpu
```
The default optional arguments are those used in the paper. A new directory will be created under the specified Tensorboard directory, and checkpoints and training progress will be written there.

## Testing
Evaluate the model using:
```
./test.py <dataset directory>/test.txt <checkpoint path> <run directory> regret_pred --use_gpu
```
The default optional arguments are those used in the paper. The search progress for all instances in the dataset will be written to the specified run directory as a pickled `pandas.DataFrame`.

For example, you can run the pretrained model using:
```
./test.py ../data/tsp100/test.txt ../models/tsp20/checkpoint_best_val.pt ../runs regret_pred --use_gpu
```

## Minimal Example
The following is a simple demonstration to help you get started 🙂
```
pipenv install
pipenv shell
cd scripts
python generate_instances.py 500 10 data
python preprocess_dataset.py data --n_train 400 --n_val 50 --n_test 50
python train.py data models --use_gpu
python test.py data/test.txt models/<new model directory>/checkpoint_best_val.pt runs regret_pred --use_gpu
```

## Citation
If you this code is useful in your research, please cite our paper:
```
@inproceedings{hudson2022graph,
    title={Graph Neural Network Guided Local Search for the Traveling Salesperson Problem},
    author={Benjamin Hudson and Qingbiao Li and Matthew Malencia and Amanda Prorok},
    booktitle={International Conference on Learning Representations},
    year={2022},
    url={https://openreview.net/forum?id=ar92oEosBIg}
}
```
