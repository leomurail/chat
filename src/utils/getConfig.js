import dotenv from 'dotenv';
dotenv.config();

const config = {
    NODE_ENV: process.env.NODE_ENV
}

export function getConfig(key) {
    return config[key];
}