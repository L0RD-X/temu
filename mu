#!/usr/bin/env bash


function get_info(){
	arc=$(dialog --title 'Passos | 1' --radiolist "Selecione a Arquitetura " 0 0 0 \
aarch64 '' OFF \
alpha   '' OFF \
arm '' OFF \
avr '' OFF \
cris    '' OFF \
hppa    '' OFF \
i386    '' OFF \
loongarch64 '' OFF \
m68k    '' OFF \
microblaze  '' OFF \
microblazeel    '' OFF \
mips    '' OFF \
mips64  '' OFF \
mips64el    '' OFF \
mipsel  '' OFF \
nios2   '' OFF \
or1k    '' OFF \
ppc '' OFF \
ppc64   '' OFF \
ppc64le '' OFF \
riscv32 '' OFF \
riscv64 '' OFF \
rx  '' OFF \
s390x   '' OFF \
sh4 '' OFF \
sh4eb   '' OFF \
sparc   '' OFF \
sparc64 '' OFF \
tricore '' OFF \
x86_64  '' OFF \
x86_64-microvm  '' OFF \
xtensa  '' OFF \
xtensaeb    '' OFF --stdout)

	hdlocal=$(dialog --title "Passo | 2 (Selecione onde Salva o HD)" --fselect "$HOME/" 16 60 --stdout)
	
	name=$(dialog --title 'Passo | 3' --inputbox "Escolha um Nome" 16 40 --stdout)
	size=$(dialog --title 'Passo | 4' --inputbox "Tamanho do HD" 16 40 --stdout)

	ram=$(dialog --title 'Passo | 5' --inputbox "Quantidade de RAM" 16 40 --stdout)
	core=$(dialog --title 'Passo | 6' --inputbox "Quantidade de Cores" 16 40 --stdout)
	iso=$(dialog --title "Passo |7 (Selecione o Arquivo de ISO)" --fselect "$HOME/" 16 60 --stdout)



}

function hd_create(){
	qemu-img create 	 \
	-f qcow2 "$name.qcow2" \
	$size
}

function Command(){

	"qemu-system-$arc" --enable-kvm \
	-m $ram 					  \
	-smp $core 					  \
	-boot d 					  \
	-hda "$hdloca/$name.qcow2"			  \
	-cdrom "$iso"
}

function confirm(){
	dialog --title "Confirmar Configuração" \
	--yesno "Nome: $name \nMemoria: $ram \nArmazenamento: $size \nNúcleos: $core \nHd Salvo em: $hdlocal \nArquitetura: $arc \nISO: $iso \nHD: $name.qcow2 \n\n As informações Estão Corretas ?" 16 40 
	case $? in
	0)	Command ;;
	1) 	trynow=$(dialog --yesno "Deseja tentar Novamente?" 16 40 --stdout)
		case $? in 
			0) get_info ;;
			1) clear && echo -e "\e[01.32m By L0RDX" ;;
			esac ;;
	esac
}
function runner(){
	get_info
	hd_create
	Command
}

runner
