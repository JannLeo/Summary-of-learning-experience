% 已知信息
N = 589; % 两个质数相乘的和
e = 17;  % 公共指数
plaintext = 42;
ciphertext = 116;

% 计算 phi(N)
phiN = phi(N);

% 计算私有指数 d
d = modinv(e, phiN);

% 显示结果
disp(['Calculated Private Key (d): ' num2str(d)]);

% 解密密文
decryptedtext = modexp(ciphertext, d, N);

% 显示解密结果
disp(['Decrypted Text: ' num2str(decryptedtext)]);

% 辅助函数
function result = modinv(a, m)
    [~, result, ~] = gcdExtended(a, m);
    result = mod(result, m);
end

function result = modexp(base, exponent, modulus)
    result = 1;
    base = mod(base, modulus);
    while exponent > 0
        if mod(exponent, 2) == 1
            result = mod(result * base, modulus);
        end
        exponent = floor(exponent / 2);
        base = mod(base^2, modulus);
    end
end

function [gcd, a_inv, b_inv] = gcdExtended(a, b)
    if a == 0
        gcd = b;
        a_inv = 0;
        b_inv = 1;
    else
        [gcd, a_inv, b_inv] = gcdExtended(mod(b, a), a);
        temp = a_inv;
        a_inv = b_inv - floor(b/a) * a_inv;
        b_inv = temp;
    end
end

function result = phi(n)
    factors = factor(n);
    result = n;
    for i = 1:length(factors)
        result = result * (1 - (1 / factors(i)));
    end
end