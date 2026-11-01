#!/bin/bash

export AWS_ACCESS_KEY_ID="XXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXX"
export AWS_SESSION_TOKEN="XXXXXX"
env | grep -E 'AWS'
