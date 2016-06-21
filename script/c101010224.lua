--アトリビュート・ゲッコー
local id,ref=GIR()
function ref.start(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetRange(LOCATION_SZONE)
	e0:SetOperation(ref.check)
	c:RegisterEffect(e0)
	local e3=e0:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e2=e0:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCode(id)
	e4:SetCountLimit(1,id)
	e4:SetLabel(0)
	e4:SetTarget(ref.tg)
	e4:SetOperation(ref.op)
	c:RegisterEffect(e4)
end
function ref.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local trg=false
	while tc do
		if tc:IsFaceup() and tc:IsSetCard(0x306) then trg=true end
		tc=eg:GetNext()
	end
	if trg then Duel.RaiseSingleEvent(c,id,e,r,rp,tp,0) end
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local at=Duel.AnnounceAttribute(tp,1,0xffff)
	e:SetLabel(at)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local at=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if at==0 or not e:GetHandler():IsRelateToEffect(e) or not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetValue(at)
	tc:RegisterEffect(e1)
end