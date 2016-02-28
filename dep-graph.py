#!/usr/bin/env python2

import sys
import os
import re

DEBUG = False

def print_help():
	print "Usage %s target_to_study [makefile dump]" % sys.argv[0]

makefile_name = "Makefile.dump"
if len(sys.argv) > 2:
	makefile_name = sys.argv[2]
else:
	# update Makefile
	os.system("export LANG=en_US; make")
	# some non-existing target to do
	os.system("export LANG=en_US; make nothing -prR > %s" % makefile_name)

if len(sys.argv) > 1:
	rootname = sys.argv[1]
else:
	print_help()
	sys.exit(1);
	
fdot = open('dep.dot', 'w')

f = open(makefile_name)

targ = {}

fdot.write("digraph G{")
fdot.write("""
	nodesep=0.3;
	ranksep=0.8;
	charset="latin1";
	rankdir=LR;
	concentrate=true;
	node [style="rounded,filled", width=0, height=0, shape=box, fillcolor="#E5E5E5"]
""")


def debug(s):
	if DEBUG:
		sys.stderr.write(s+"\n")

def process(s):
	s = s.strip()
	if s.find("files/") > -1 or s.find("Archive/") > -1:
		return ''
	l = s.split('/')
	if s.find(".deps") < 0:
		if len(l) < 2:
			s = l[-1]
		else:
			s = l[-2] +'/' + l[-1]
	else:
		s = l[-1]
	if s == "|":
		return ''
	return s
	
	
started = False

def uniq(l):
	return list(set(l))

while True:
	line = f.readline()
	if not line:
		break
	if line.startswith("# Files"):
		started = True
	if line.startswith("# Not a target:"):
		f.readline()
		continue
	if not started:
		continue
	if line.startswith("#") or line.startswith("\t"):
		continue
	if not line.strip():
		continue
	debug( "line: " + line.strip() )
	if line.find("::") > -1:
		continue
	l = line.split(":")
	if len(l) < 2:
		continue
	name = process(l[0])
	if not name:
		continue
	deps = []
	if len(l) > 1:
		deps = l[1].split(' ')
	d = []
	for i in range(len(deps)):
		deps[i] = process(deps[i])
		if not deps[i]:
			continue
		d += [deps[i]]
	deps = uniq(d)
	debug( "adding %s: %s" % (name, ' '.join(deps)) )
	if name in targ:
		raise Exception("ERROR: %s duplicate" % name)
	targ[name] = deps

# removes vertex x and all its connections
# so graph may be splitted, be careful
def ignore(x):
	if x.find('.version_') > -1:
		return True
	return False

# joins vertex x and all its connections with returned vertex
def parent(x):
	sufixes = ['.do_depends', '.do_prepare', '.do_compile', '.do_package', '.do_ipk', '.do_tar', '.set_inherit_vars', '.do_git_version', '.write_git_version', '.include_git_version', '.do_srcrev', '.do_split', '.do_ipkbox', '.do_install', '.files_fake', '.do_controls', '.include_provides', '.write_provides']
	for s in sufixes:
		if x.endswith(s):
			return x.replace(s, '')
	return None

targ2 = {}
for x in targ:
	if ignore(x):
		continue
	
	p = parent(x)
	if p:
		key = p
	else:
		key = x
	try:
		targ2[key] += targ[x]
	except KeyError:
		targ2[key] = targ[x]

targ = targ2
targ2 = {}
for x in targ:
	targ2[x] = []
	for dep in targ[x]:
		if ignore(dep):
			continue
		p = parent(dep)
		if not p:
			p = dep
		if p != x:
			targ2[x].append(p)

targ = targ2
del targ2

def DFS(start, do_cmd):
	curr = start
	walk = []
	last = {}
	while True:
		
		# where can we go from here ?
		if curr in targ:
			children = targ[curr]
		else:
			print "WARNING: unknown dependency", curr
			children = []
	
		# have we been here before ?
		if curr in last:
			idx = last[curr] + 1
		else:
			idx = 0
		
		if idx >= len(children):
			# visited all children, go up
			if len(walk) == 0:
				break
			curr = walk.pop()
			#print '<', curr
		else:
			# visit next child
			ne = children[idx]
			print_dep(curr, ne)
			if ne in walk:
				print "ERROR: broke loop at", curr, '->', ne
				last[curr] = idx
				continue
			last[curr] = idx
			walk.append(curr)
			curr = ne
			#print '>', curr

def print_dep(target, dependency):
	fdot.write(' "%s" -> "%s" ;\n' % (target, dependency))

if rootname:
	DFS(rootname, print_dep)
else:
	for x in targ:
		for y in targ[x]:
			print_dep(x,y)

fdot.write("}")
fdot.close()

print "Drawing graph...."
cmd = "cat dep.dot |tred |dot -Tsvg -o dot.svg"
print "exec:", cmd
os.system(cmd)
print "output is in dot.svg"
