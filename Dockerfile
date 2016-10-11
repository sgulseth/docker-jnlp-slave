# The MIT License
#
#  Copyright (c) 2015, CloudBees, Inc.
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

FROM openjdk:8-jdk
MAINTAINER Nicolas De Loof <nicolas.deloof@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
  docker.io \
  && rm -rf /var/lib/apt/lists/*

ENV HOME /home/jenkins
RUN useradd -c "Jenkins user" -d $HOME -m jenkins
RUN usermod -a -G docker jenkins

ARG VERSION=2.60

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

RUN curl -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.2.4/bin/linux/amd64/kubectl \
 && chmod +x /usr/local/bin/kubectl

COPY jenkins-slave /usr/local/bin/jenkins-slave

VOLUME /var/run/docker.sock
VOLUME /home/jenkins
WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-slave"]
