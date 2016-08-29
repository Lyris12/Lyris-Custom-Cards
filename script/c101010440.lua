--ソウル・インバージョン・チャネル－緑
function c101010440.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101010440.op)
	c:RegisterEffect(e1)
end
c101010440.global_check=false
function c101010440.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c101010440.global_check then return end
	c101010440.global_check=true
	local g=Duel.GetFieldGroup(tp,0xff,0xff)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsSetCard(0xe9) then
			if bit.band(tc:GetType(),0x11)==0x11 then
				aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,tc:GetRace()),2,true)
				local e1=Effect.CreateEffect(tc)
				e1:SetDescription(aux.Stringid(101010261,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetValue(TYPE_MONSTER+TYPE_FUSION)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2:SetCode(EVENT_SUMMON_SUCCESS)
				e2:SetOperation(c101010440.atklimit)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
				tc:RegisterEffect(e3)
				local e4=e2:Clone()
				e4:SetCode(EVENT_SPSUMMON_SUCCESS)
				tc:RegisterEffect(e4)
			end
		end
		tc=g:GetNext()
	end
end
function c101010440.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
