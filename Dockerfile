FROM alpine:latest

# လိုအပ်တဲ့ Tools များ install လုပ်ခြင်း
RUN apk add --no-cache wget unzip ca-certificates

# 1. Xray core ကို install လုပ်ခြင်း
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip Xray-linux-64.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm -rf Xray-linux-64.zip

# 2. Cloudflared ကို install လုပ်ခြင်း
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

WORKDIR /etc/xray
# သင့် Project ထဲမှာ config.json file ရှိနေရပါမယ်
COPY config.json .

# Xray ကို background မှာ run ပြီး Cloudflared ကို သင့်ရဲ့ Token နဲ့ run မယ်
# Token ကို Dockerfile ထဲ တိုက်ရိုက်ထည့်တာထက် Variable သုံးတာ ပိုမှန်ပါတယ်
CMD xray run -c /etc/xray/config.json & cloudflared tunnel --no-autoupdate run --token eyJhIjoiNTBlNjY3NDA4YTBjMWQ1MmVmNTBhZmIyNGViNmViOGEiLCJ0IjoiM2RkMTAwZjYtOTQwMS00MDZiLTlhM2MtZGE2MDc3ZWViMTAyIiwicyI6IllUazJaV1k0TkRrdE1EZ3lPUzAwWXpnMUxUbGlaVFF0WXpZNE9Ua3hOVFExTm1FdyJ9
