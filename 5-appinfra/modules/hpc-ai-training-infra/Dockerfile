# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM tensorflow/tensorflow:latest-gpu@sha256:1f16fbd9be8bb84891de12533e332bbd500511caeb5cf4db501dbe39d422f9c7
WORKDIR /data/tensorflow-mnist-example
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["/bin/bash", "-c", "--", "python tensorflow_mnist_train_distributed.py"]
