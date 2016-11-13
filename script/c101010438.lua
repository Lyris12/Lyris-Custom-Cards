--created & coded by Lyris
--ソウル・インバージョン・チャネル－灰
function c101010438.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101010438.op)
	c:RegisterEffect(e1)
end
c101010438.global_check=false
function c101010438.filter(c)
	local code=c:GetOriginalCode()
	return code==100000150 or code==100000151 or code==100000152 or code==101010259 or code==100000154 or code==100000155 or code==100000156 or (c:IsSetCard(0x301) and c:IsType(TYPE_SYNCHRO))
end
function c101010438.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c101010438.global_check then return end
	c101010438.global_check=true
	local g=Duel.GetFieldGroup(tp,0xff,0xff)
	g:RemoveCard(c)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsSetCard(0xe9) then
			if c101010438.filter(tc) then
				local e0=Effect.CreateEffect(c)
				e0:SetDescription(aux.Stringid(101010259,1))
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				e0:SetValue(1)
				tc:RegisterEffect(e0)
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(101010259,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				tc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_SYNCHRO) then
				local tpe=TYPE_MONSTER+TYPE_XYZ+TYPE_EFFECT
				if not tc:IsType(TYPE_EFFECT) then tpe=tpe-TYPE_EFFECT end
				local e0=Effect.CreateEffect(tc)
				e0:SetDescription(aux.Stringid(101010259,0))
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_CHANGE_TYPE)
				e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e0:SetValue(tpe)
				tc:RegisterEffect(e0)
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_SPSUMMON_PROC)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
				e1:SetRange(LOCATION_EXTRA)
				e1:SetCondition(c101010438.syncon)
				e1:SetOperation(c101010438.synop)
				e1:SetValue(SUMMON_TYPE_XYZ)
				tc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_XYZ) and tc:GetEffectCount(EFFECT_CHANGE_RANK)==0 and tc:GetEffectCount(EFFECT_REMOVE_TYPE)==0 then
				local tpe=TYPE_MONSTER+TYPE_SYNCHRO+TYPE_EFFECT
				if not tc:IsType(TYPE_EFFECT) then tpe=tpe-TYPE_EFFECT end
				local e0=Effect.CreateEffect(tc)
				e0:SetDescription(aux.Stringid(101010259,3))
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_CHANGE_TYPE)
				e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e0:SetValue(tpe)
				tc:RegisterEffect(e0)
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_SPSUMMON_PROC)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
				e1:SetRange(LOCATION_EXTRA)
				e1:SetCondition(c101010438.xyzcondition)
				e1:SetOperation(c101010438.xyzoperation)
				e1:SetValue(SUMMON_TYPE_SYNCHRO)
				tc:RegisterEffect(e1)
			end
		end
		tc=g:GetNext()
	end
end
function c101010438.matfilter(c,syncard)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(syncard)
end
function c101010438.synfilter1(c,lv,g)
	local tlv=c:GetLevel()
	return g:IsExists(c101010438.synfilter2,1,c,lv,tlv)
end
function c101010438.synfilter2(c,tlv,lv)
	return c:GetLevel()+lv==tlv
end
function c101010438.syncon(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g=Duel.GetMatchingGroup(c101010438.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if lv==nil then lv=c:GetRank() end
	return g:IsExists(c101010438.synfilter1,1,nil,lv,g)
end
function c101010438.synop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(c101010438.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	if lv==nil then lv=c:GetRank() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local m=g:FilterSelect(tp,c101010438.synfilter1,1,1,nil,lv,g):GetFirst()
	mg:AddCard(m)
	local lv1=m:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local t=g:FilterSelect(tp,c101010438.synfilter2,1,1,m,lv,lv1)
	mg:Merge(t)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
function c101010438.xmfilter(c,xyzc)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(xyzc)
end
function c101010438.xfilter(c,lv,g)
	local tlv=c:GetLevel()
	return g:IsExists(c101010438.xyzfilter,1,c,lv,tlv)
end
function c101010438.xyzfilter(c,tlv,lv)
	return c:GetLevel()+lv==tlv
end
function c101010438.xyzcondition(e,c,tuner)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g=Duel.GetMatchingGroup(c101010438.xmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetRank()
	if lv==nil then lv=c:GetLevel() end
	return g:IsExists(c101010438.xfilter,1,nil,lv,g)
end
function c101010438.xyzoperation(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local mg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(c101010438.xmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetRank()
	if lv==nil then lv=c:GetLevel() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local m=g:FilterSelect(tp,c101010438.xfilter,1,1,nil,lv,g):GetFirst()
	mg:AddCard(m)
	local lv1=m:GetLevel()
	local t=g:FilterSelect(tp,c101010438.xyzfilter,1,1,m,lv,lv1)
	mg:Merge(t)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
end
