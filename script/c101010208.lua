--ＳＳ－静かなる潮ソティレオ
function c101010208.initial_effect(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c101010208.matcheck)
	c:RegisterEffect(e0)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101010208.con)
	e2:SetOperation(c101010208.op)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101010208.lvtg)
	e1:SetOperation(c101010208.lvop)
	c:RegisterEffect(e1)
end
function c101010208.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsLevelAbove(1) end
	local t={}
	local i=1
	local p=1
	local lv=c:GetLevel()
	for i=1,12 do 
		if lv~=i and math.abs(i-lv)<=3 then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c101010208.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c101010208.matcheck(e,c)
	local g=c:GetMaterial()
	local alec=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsType(TYPE_TUNER) and tc:IsAttribute(ATTRIBUTE_WATER) then alec=alec+1 end
		tc=g:GetNext()
	end
	e:SetLabel(alec)
end
function c101010208.con(e,tp,eg,ep,ev,re,r,rp)
	local alec=e:GetLabelObject():GetLabel()
	return alec~=0 and e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c101010208.op(e,tp,eg,ep,ev,re,r,rp)
	local alec=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if alec~=0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(c101010208.val)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
function c101010208.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c101010208.val(e,c)
	return Duel.GetMatchingGroupCount(c101010208.filter,tp,LOCATION_MZONE,0,nil)*300
end
