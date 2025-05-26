IMAGE_NAME=dumprx-image

.PHONY: build run


build:
	docker build -t $(IMAGE_NAME) .

# Run the container with given firmware and output directory
# Usage: make run FIRMWARE=/path/to/firmware.bin OUTPUT=/path/to/output_dir
run:
ifndef FIRMWARE
	$(error FIRMWARE path is required, e.g. make run FIRMWARE=/path/to/firmware.bin OUTPUT=/path/to/output)
endif
ifndef OUTPUT
	$(error OUTPUT directory is required, e.g. make run FIRMWARE=/path/to/firmware.bin OUTPUT=/path/to/output)
endif
	@firmware_file=$$(basename $(FIRMWARE)); \
	docker run --rm -it \
		-v "$(OUTPUT)":/data/results \
		-v "$(FIRMWARE)":/data/$$firmware_file \
		$(IMAGE_NAME) \
		/data/$$firmware_file