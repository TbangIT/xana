# --- INIZIO BLOCCO KERNEL CACHYOS ---

echo "::group::Installazione Kernel CachyOS e Nvidia"

# 1. Abilita il Copr di CachyOS
dnf copr enable -y bieszczaders/kernel-cachyos

# 2. Rimuovi i pacchetti del kernel Fedora originale
# Usiamo rpm -e --nodeps perché dnf si rifiuterebbe di rimuovere il kernel in uso/protetto
echo "Rimozione kernel stock Fedora..."
rpm -qa | grep -E "^kernel-(core|modules|modules-core|modules-extra)" | xargs rpm -e --nodeps || true

# 3. Installa Kernel CachyOS e dipendenze per la compilazione
# Nota: installiamo anche 'akmod-nvidia' per essere sicuri che sia presente
echo "Installazione pacchetti CachyOS..."
dnf install -y \
    kernel-cachyos \
    kernel-cachyos-core \
    kernel-cachyos-modules \
    kernel-cachyos-modules-extra \
    kernel-cachyos-devel \
    kernel-cachyos-headers \
    akmod-nvidia \
    libucm # A volte richiesto come dipendenza extra

# 4. Ricompila i driver Nvidia per il nuovo kernel
echo "Ricompilazione moduli Nvidia (akmods)..."
# Recupera la versione esatta del kernel cachyos appena installato
CACHY_KERNEL_VERSION=$(rpm -qa kernel-cachyos --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')

# Forza la costruzione del kmod nvidia contro il kernel CachyOS
akmods --force --kernels "${CACHY_KERNEL_VERSION}"

# Verifica che il modulo kmod-nvidia sia stato creato (opzionale, per debug nei log)
ls -l /var/cache/akmods/nvidia/

# 5. Pulizia dei pacchetti di sviluppo (Opzionale: risparmia spazio ma impedisce ricompilazioni future locali)
# Se vuoi l'immagine più leggera possibile scommenta la riga sotto:
# dnf remove -y kernel-cachyos-devel kernel-cachyos-headers

echo "::endgroup::"
# --- FINE BLOCCO KERNEL CACHYOS ---
