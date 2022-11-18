.PHONY: build
name=webui
fullname=${name}:latest
HF_MODEL=runwayml/stable-diffusion-v1-5
HF_CACHE=${HOME}/workspace/models/hf/cache
UID=$(shell id -u)
GID=$(shell id -g)
USER_NAME=$(shell id -un)

build:
	# --build-arg UID=${UID} \
	# --build-arg GID=${GID} \
	# --build-arg USER_NAME=${USER_NAME} \
	DOCKER_BUILDKIT=1 docker build \
		-t ${name} .
	docker tag ${name} ${fullname}

run:
	docker run --rm --runtime=nvidia -it \
		-p 8080:8080\
		-v ${PWD}/models:/app/models \
		-v ${PWD}/repositories:/app/repositories \
		${fullname} 

# 	docker run --rm --runtime=nvidia ${fullname} nvcc --version
# 	docker run --rm -v ${PWD}/scripts:/app ${fullname} python3 /app/test_container.py

# run:
# 	docker run --rm -it -v ${HOME}/workspace/ml/models:/models/ ${fullname} /bin/bash

# download:
# 	docker run --rm -it -v ${HF_CACHE}:/models \
# 		-e HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN} \
# 		hfdownloader:latest \
# 		--model-id ${HF_MODEL} \
# 		--cache-dir /models \
# 		--revision fp16

# profile:
# 	docker run --rm -t \
# 		-v ${PWD}/scripts:/app \
# 		-v ${HOME}/workspace/models/hf/cache:/models \
# 		-e HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN} \
# 		${fullname} \
# 		python3 /app/profile_container.py --model-id ${HF_MODEL} --cache-dir /models

# bash:
# 	docker run --rm -it \
# 		-v ${HF_CACHE}:/models \
# 		${fullname} /bin/bash

# zip:
# 	# zip the model weights
# 	mkdir -p ${HOME}/workspace/compressed/${HF_MODEL}
# 	docker run --rm -it \
# 		-v ${PWD}:/handler \
# 		-v ${HF_CACHE}:/models \
# 		-v ${HOME}/workspace/compressed/${HF_MODEL}:/output \
# 		-w /handler \
# 		zip:latest \
# 			zip -1 -r /output/model.zip /models

# package:
# 	# create archive
# 	docker run --rm -it \
# 		-v ${PWD}/handler:/handler \
# 		-v ${HOME}/workspace/compressed/${HF_MODEL}:/output \
# 		-v ${HOME}/workspace/torchserve/:/export \
# 		-w /handler \
# 		pytorch/torchserve:latest \
# 		torch-model-archiver \
# 				--model-name stable-diffusion --version 1.5 --handler stable_diffusion_handler.py --extra-files /output/model.zip -r requirements.txt --export-path /export

# serve:
# 	docker run --rm -it \
# 		-v ${HOME}/workspace/compressed/${HF_MODEL}:/models \
# 		-p 8080:8080 -p 8081:8081 -p 8082:8082 -p 7070:7070 -p 7071:7071 \
# 		pytorch/torchserve:latest \
# 		--model-store /models


# profile:
# 	docker run --rm -t \
# 		-v ${PWD}/scripts:/app \
# 		-v ${HOME}/workspace/models/hf/cache:/models \
# 		-e HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN} \
# 		${fullname} \
# 		python3 /app/profile_container.py --model-id ${HF_MODEL} --cache-dir /models


# CHECKPOINT="models--prompthero/linkedin-diffusion/"
# CHECKPOINT="/models/models--SpiteAnon--gigachad-diffusion/snapshots/d27fdc34d72b03d3019d44c6b519032595987433/gigachad_2000.ckpt"
# CHECKPOINT="/models/models--prompthero--linkedin-diffusion/snapshots/4d9814d59593e74305f2cfebca46cf729cea56d1/lnkdn.ckpt"
# OUTPUT_DIR=${HOME}/workspace/${model}/fabrizio/default/

# generate:
# 	mkdir -p ${OUTPUT_DIR}

# 	docker run --rm -t -it \
# 		-v ${PWD}/scripts:/app \
# 		-v ${HOME}/workspace/models/hf/cache:/models \
# 		-v ${HOME}/workspace/${HF_MODEL}/fabrizio/default/:/output\
# 		-e HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN} \
# 		${fullname} \
# 		bash -c "python3 -m pip install ipdb && python3 /app/generate.py --model-id ${HF_MODEL} --checkpoint ${CHECKPOINT} --cache-dir /models  --output-dir /output --revision fp16"
